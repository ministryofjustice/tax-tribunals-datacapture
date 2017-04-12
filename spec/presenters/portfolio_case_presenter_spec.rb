require 'spec_helper'

RSpec.describe PortfolioCasePresenter do
  subject { described_class.new(tribunal_case) }

  let(:tribunal_case) { instance_double(TribunalCase, tribunal_case_attributes) }
  let(:tribunal_case_attributes) {
    {
      taxpayer_type: taxpayer_type,
      taxpayer_individual_first_name: 'John',
      taxpayer_individual_last_name: 'Harrison',
      taxpayer_organisation_fao: 'TP Org Fao',
      created_at: created_at
    }
  }
  let(:taxpayer_type) { nil }
  let(:created_at) { Time.at(0) }

  describe '#created_at' do
    it { expect(subject.created_at).to eq('01 January 1970') }
  end

  describe '#taxpayer_name' do
    context 'for an individual filling the form' do
      let(:taxpayer_type) { ContactableEntityType::INDIVIDUAL }
      it { expect(subject.taxpayer_name).to eq('John Harrison') }
    end

    context 'for an organisation filling the form' do
      let(:taxpayer_type) { ContactableEntityType::COMPANY }
      it { expect(subject.taxpayer_name).to eq('TP Org Fao') }
    end
  end
end
