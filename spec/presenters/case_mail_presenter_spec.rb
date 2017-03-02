require 'spec_helper'

RSpec.describe CaseMailPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { TribunalCase.new(tribunal_case_attributes) }
  let(:tribunal_case_attributes) {
    {
      user_type: user_type,
      case_reference: case_reference,
      taxpayer_contact_email: 'taxpayer@example.com',
      taxpayer_individual_first_name: 'John',
      taxpayer_individual_last_name: 'Harrison',
      representative_contact_email: 'representative@example.com',
      representative_individual_first_name: 'Stewart',
      representative_individual_last_name: 'Quinten',
    }
  }
  let(:user_type) { UserType::TAXPAYER }
  let(:case_reference) { 'TC/2017/00001' }

  describe '#case_reference' do
    context 'for a case with reference number' do
      it { expect(subject.case_reference).to eq('TC/2017/00001') }
    end

    context 'for a case without reference number' do
      let(:case_reference) { nil }
      it { expect(subject.case_reference).to eq('') }
    end
  end

  describe '#show_case_reference?' do
    context 'for a case with reference number' do
      it { expect(subject.show_case_reference?).to eq('yes') }
    end

    context 'for a case without reference number' do
      let(:case_reference) { nil }
      it { expect(subject.show_case_reference?).to eq('no') }
    end
  end

  describe '#recipient_email' do
    context 'for a taxpayer filling the form' do
      it { expect(subject.recipient_email).to eq('taxpayer@example.com') }
    end

    context 'for a representative filling the form' do
      let(:user_type) { UserType::REPRESENTATIVE }
      it { expect(subject.recipient_email).to eq('representative@example.com') }
    end
  end

  describe '#recipient_first_name' do
    context 'for a taxpayer filling the form' do
      it { expect(subject.recipient_first_name).to eq('John') }
    end

    context 'for a representative filling the form' do
      let(:user_type) { UserType::REPRESENTATIVE }
      it { expect(subject.recipient_first_name).to eq('Stewart') }
    end
  end

  describe '#recipient_last_name' do
    context 'for a taxpayer filling the form' do
      it { expect(subject.recipient_last_name).to eq('Harrison') }
    end

    context 'for a representative filling the form' do
      let(:user_type) { UserType::REPRESENTATIVE }
      it { expect(subject.recipient_last_name).to eq('Quinten') }
    end
  end
end
