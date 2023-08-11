require 'spec_helper'

RSpec.describe Steps::Details::SendApplicationDetailsForm do
  let(:user_type) { UserType::TAXPAYER }
  let(:tribunal_case) do
    TribunalCase.new(
      user_type: user_type,
      taxpayer_contact_email: 'taxpayer@email.com',
      taxpayer_contact_phone: '07777777777',
      representative_contact_email: 'representative@email.com',
      representative_contact_phone: '07777777777',
    )
  end
  let(:default_attributes) do
    {
      send_to: user_type,
      send_application_details: 'both',
      email_address: "#{user_type}@email.com",
      phone_number: "07777777777",
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
          .with({ "send_#{entity}_copy".to_sym => SendApplicationDetails.new(:both)})
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

        context 'when send_application_details value is none' do
          let(:attributes) { {send_application_details: 'none'} }
          specify { expect(subject).to be_valid }
        end

        context 'when send_application_details value is email and email_address doesnt match' do
          let(:attributes) { {send_application_details: 'email', email_address: 'no@nn.com'} }
          specify { expect(subject).not_to be_valid }
          specify { expect(subject.errors.details[:email_address]).to eq([{error: "different_#{entity}".to_sym}])}
        end

        context 'when send_application_detail value is both and both match' do
          specify { expect(subject).to be_valid }
        end

        context 'when send_application_detail value is email email must be provided' do
          let(:tribunal_case) do
            TribunalCase.new(
              user_type: user_type,
              taxpayer_contact_email: nil,
              representative_contact_email: nil
            )
          end
          let(:attributes) { {send_application_details: 'email', email_address: nil} }

          specify { expect(subject).not_to be_valid }
          specify { expect(subject.errors.details[:email_address]).to eq([{error: :blank}]) }
        end

        context 'when send_application_detail value is text, phone number must be provided' do
          let(:tribunal_case) do
            TribunalCase.new(
              user_type: user_type,
              taxpayer_contact_email: nil,
              representative_contact_email: nil
            )
          end
          let(:attributes) { {send_application_details: 'text', phone_number: nil} }

          specify { expect(subject).not_to be_valid }
          specify { expect(subject.errors.details[:phone_number]).to eq([{error: :blank}]) }
        end
      end
    end
  end

  describe 'validations for phone_number match' do
    let(:attributes) { {send_application_details: 'text', phone_number: '0111'} }
    before { subject.valid? }

    context 'when send_application_details value is text, phone_number doesnt match and is taxpayer' do
      let(:user_type) { UserType::TAXPAYER }

      specify { expect(subject).not_to be_valid }
      specify { expect(subject.errors.details[:phone_number]).to eq([{error: "different_#{user_type}".to_sym}])}
    end

    context 'when send_application_details value is text, phone_number doesnt match and is representative' do
      let(:user_type) { UserType::REPRESENTATIVE }
      specify { expect(subject).not_to be_valid }
      specify { expect(subject.errors.details[:phone_number]).to eq([{error: "different_#{user_type}".to_sym}])}
    end
  end
end
