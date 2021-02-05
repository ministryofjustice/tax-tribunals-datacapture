require 'spec_helper'

RSpec.describe Steps::Details::SendApplicationDetailsForm do
  let(:user_type) { UserType::TAXPAYER }
  let(:tribunal_case) do
    TribunalCase.new(
      user_type: user_type,
      taxpayer_contact_email: 'taxpayer@email.com',
      representative_contact_email: 'representative@email.com'
    )
  end
  let(:default_attributes) do
    {
      send_to: user_type,
      send_application_details: 'yes',
      email_address: "#{user_type}@email.com"
    }
  end
  let(:attributes) { {} }
  subject! do
    described_class
      .new(default_attributes.merge(attributes))
      .tap { |o| o.tribunal_case = tribunal_case }
  end

  describe 'constant' do
    it 'has a mapping for taxpayer and representative' do
      expected_hash = {
        UserType::TAXPAYER       => :send_taxpayer_copy,
        UserType::REPRESENTATIVE => :send_representative_copy
      }
      expect(subject.class::TRIBUNAL_CASE_ENTITY_MAPPING).to eq(expected_hash)
    end
  end

  [UserType::TAXPAYER, UserType::REPRESENTATIVE].each do |entity|
    describe ".persist! for #{entity} "do
      let(:user_type) { entity }

      it 'saves when field send_application_details changed' do
        expect(tribunal_case).to receive(:update)
          .with({ "send_#{entity}_copy".to_sym => SendApplicationDetails.new(:yes)})
        subject.send(:persist!)
      end
    end

    describe 'validations' do
      context "for #{entity}" do
        let(:user_type) { entity }
        before { subject.valid? }

        context 'when send_application_details is missing' do
          let(:attributes) { {send_application_details: nil } }
          specify { expect(subject).not_to be_valid }
          specify { expect(subject.errors.details[:send_application_details]).to eq([{error: "send_#{entity}_copy".to_sym}])}
        end

        context 'when send_application_details value is no' do
          let(:attributes) { {send_application_details: 'no'} }
          specify { expect(subject).to be_valid }
        end

        context 'when send_application_details value is yes and email_address missing' do
          let(:attributes) { {send_application_details: 'yes', email_address: nil} }
          specify { expect(subject).not_to be_valid }
          specify { expect(subject.errors.details[:email_address]).to eq([{error: "different_#{entity}".to_sym}])}
        end

        context 'when send_application_details value is yes and email_address doesnt match' do
          let(:attributes) { {send_application_details: 'yes', email_address: 'no@nn.com'} }
          specify { expect(subject).not_to be_valid }
          specify { expect(subject.errors.details[:email_address]).to eq([{error: "different_#{entity}".to_sym}])}
        end

        context 'when send_application_detail value is yes and email_address matches' do
          specify { expect(subject).to be_valid }
        end
      end
    end
  end
end
