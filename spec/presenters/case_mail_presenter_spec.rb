require 'spec_helper'

RSpec.describe CaseMailPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { TribunalCase.new(tribunal_case_attributes) }
  let(:tribunal_case_attributes) {
    {
      user_type: user_type,
      taxpayer_type: taxpayer_type,
      representative_type: representative_type,
      case_reference: case_reference,
      taxpayer_contact_email: 'taxpayer@example.com',
      taxpayer_individual_first_name: 'John',
      taxpayer_individual_last_name: 'Harrison',
      taxpayer_organisation_fao: 'TP Org Fao',
      representative_contact_email: 'representative@example.com',
      representative_individual_first_name: 'Stewart',
      representative_individual_last_name: 'Quinten',
      representative_organisation_fao: 'Rep Org Fao'
    }
  }
  let(:user_type) { nil }
  let(:taxpayer_type) { nil }
  let(:representative_type) { nil }
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
    context 'when case was started by the taxpayer' do
      let(:user_type) { UserType::TAXPAYER }
      it { expect(subject.recipient_email).to eq('taxpayer@example.com') }
    end

    context 'when case was started by a representative' do
      let(:user_type) { UserType::REPRESENTATIVE }
      it { expect(subject.recipient_email).to eq('representative@example.com') }
    end
  end

  describe '#recipient_name' do
    context 'when case was started by the taxpayer' do
      let(:user_type) { UserType::TAXPAYER }

      context 'for an individual filling the form' do
        let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }
        it { expect(subject.recipient_name).to eq('John Harrison') }
      end

      context 'for an organisation filling the form' do
        let(:taxpayer_type) { ContactableEntityType::COMPANY }
        it { expect(subject.recipient_name).to eq('TP Org Fao') }
      end
    end

    context 'when case was started by a representative' do
      let(:user_type) { UserType::REPRESENTATIVE }

      context 'for an individual filling the form' do
        let(:representative_type) { ContactableEntityType::INDIVIDUAL }
        it { expect(subject.recipient_name).to eq('Stewart Quinten') }
      end

      context 'for an organisation filling the form' do
        let(:representative_type) { ContactableEntityType::COMPANY }
        it { expect(subject.recipient_name).to eq('Rep Org Fao') }
      end
    end
  end
end
