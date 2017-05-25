require 'spec_helper'

RSpec.describe CaseMailPresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { TribunalCase.new(tribunal_case_attributes) }
  let(:tribunal_case_attributes) {
    {
      intent: intent,
      user_type: user_type,
      taxpayer_type: taxpayer_type,
      representative_type: representative_type,
      case_reference: case_reference,
      taxpayer_contact_email: 'taxpayer@example.com',
      taxpayer_individual_first_name: 'John',
      taxpayer_individual_last_name: 'Harrison',
      representative_contact_email: 'representative@example.com',
      representative_individual_first_name: 'Stewart',
      representative_individual_last_name: 'Quinten'
    }.merge(additional_attributes)
  }

  let(:intent) { Intent::TAX_APPEAL }
  let(:user_type) { nil }
  let(:taxpayer_type) { nil }
  let(:representative_type) { nil }
  let(:additional_attributes) { {} }
  let(:case_reference) { 'TC/2017/00001' }
  let(:user) { instance_double(User, email: 'user@example.com') }

  describe '#case_reference' do
    context 'for a case with reference number' do
      it { expect(subject.case_reference).to eq('TC/2017/00001') }
    end

    context 'for a case without reference number' do
      let(:case_reference) { nil }
      it { expect(subject.case_reference).to eq('') }
    end
  end

  describe '#case_reference_present?' do
    context 'for a case with reference number' do
      it { expect(subject.case_reference_present?).to eq('yes') }
    end

    context 'for a case without reference number' do
      let(:case_reference) { nil }
      it { expect(subject.case_reference_present?).to eq('no') }
    end
  end

  describe '#case_reference_absent?' do
    context 'for a case with reference number' do
      it { expect(subject.case_reference_absent?).to eq('no') }
    end

    context 'for a case without reference number' do
      let(:case_reference) { nil }
      it { expect(subject.case_reference_absent?).to eq('yes') }
    end
  end

  describe '#account_user_email' do
    before do
      allow(tribunal_case).to receive(:user).and_return(user)
    end

    it 'returns the email address from the User account' do
      expect(subject.account_user_email).to eq('user@example.com')
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
        let(:additional_attributes) { {taxpayer_organisation_fao: 'TP Org Fao'} }

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
        let(:additional_attributes) { {representative_organisation_fao: 'Rep Org Fao'} }

        it { expect(subject.recipient_name).to eq('Rep Org Fao') }
      end
    end
  end

  describe '#company_name' do
    context 'when case was started by the taxpayer' do
      let(:user_type) { UserType::TAXPAYER }

      context 'for an individual filling the form' do
        let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }
        it { expect(subject.company_name).to eq('') }
      end

      context 'for an organisation filling the form' do
        let(:taxpayer_type) { ContactableEntityType::COMPANY }
        let(:additional_attributes) { {taxpayer_organisation_name: 'TP Org Name'} }

        it { expect(subject.company_name).to eq('TP Org Name') }
      end
    end

    context 'when case was started by a representative' do
      let(:user_type) { UserType::REPRESENTATIVE }

      context 'for an individual filling the form' do
        let(:representative_type) { ContactableEntityType::INDIVIDUAL }
        it { expect(subject.company_name).to eq('') }
      end

      context 'for an organisation filling the form' do
        let(:representative_type) { ContactableEntityType::COMPANY }
        let(:additional_attributes) { {representative_organisation_name: 'Rep Org Name'} }

        it { expect(subject.company_name).to eq('Rep Org Name') }
      end
    end
  end

  describe '#show_company_name?' do
    context 'for a case with a company name' do
      before do
        expect(subject).to receive(:company_name).and_return('Company Ltd.')
      end

      it { expect(subject.show_company_name?).to eq('yes') }
    end

    context 'for a case without a company name' do
      before do
        expect(subject).to receive(:company_name).and_return('')
      end

      it { expect(subject.show_company_name?).to eq('no') }
    end
  end

  describe '#show_deadline_warning?' do
    context 'for a tax appeal case' do
      let(:intent) { Intent::TAX_APPEAL }
      it { expect(subject.show_deadline_warning?).to eq('yes') }
    end

    context 'for a closure case' do
      let(:intent) { Intent::CLOSE_ENQUIRY }
      it { expect(subject.show_deadline_warning?).to eq('no') }
    end
  end

  describe '#ftt_recipient_email' do
    it 'should retrieve it from the ENV' do
      expect(ENV).to receive(:fetch).with('TAX_TRIBUNAL_EMAIL')
      subject.ftt_recipient_email
    end
  end

  describe '#survey_link' do
    it 'should retrieve it from the Rails config' do
      expect(Rails).to receive_message_chain(:configuration, :survey_link)
      subject.survey_link
    end
  end

  describe '#draft_expire_in_days' do
    it 'should retrieve it from the Rails config' do
      expect(Rails).to receive_message_chain(:configuration, :x, :cases, :expire_in_days)
      subject.draft_expire_in_days
    end
  end
end
