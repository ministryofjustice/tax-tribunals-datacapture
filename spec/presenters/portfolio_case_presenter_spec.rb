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
  let(:created_at) { DateTime.now }

  before do
    travel_to Time.at(0)
  end

  describe '#expires_in' do
    context 'case created today' do
      let(:created_at) { DateTime.now }
      it { expect(subject.expires_in).to eq('14 days') }
    end

    context 'case created 7 days ago' do
      let(:created_at) { 7.days.ago }
      it { expect(subject.expires_in).to eq('7 days') }
    end

    context 'case created 13 days ago' do
      let(:created_at) { 13.days.ago }
      it { expect(subject.expires_in).to eq('1 day') }
    end

    context 'case created 14 days ago' do
      let(:created_at) { 14.days.ago }
      it { expect(subject.expires_in).to eq('Today') }
    end

    # This is to ensure even if we don't purge the case on time for whatever reason,
    # the user will not see weird data (better to continue saying 'Today').
    context 'case created 15 days ago' do
      let(:created_at) { 15.days.ago }
      it { expect(subject.expires_in).to eq('Today') }
    end
  end

  describe '#expires_in_class' do
    context 'case created today' do
      let(:created_at) { DateTime.now }
      it { expect(subject.expires_in_class).to eq('') }
    end

    context 'case created 7 days ago' do
      let(:created_at) { 7.days.ago }
      it { expect(subject.expires_in_class).to eq('') }
    end

    context 'case created 9 days ago' do
      let(:created_at) { 9.days.ago }
      it { expect(subject.expires_in_class).to eq('expires-soon') }
    end

    context 'case created 14 days ago' do
      let(:created_at) { 14.days.ago }
      it { expect(subject.expires_in_class).to eq('expires-today') }
    end
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

  describe '#taxpayer_name?' do
    let(:taxpayer_type) { ContactableEntityType::COMPANY }

    it { expect(subject.taxpayer_name?).to eq(true) }

    context 'when no name is given' do
      let(:tribunal_case_attributes) { super().merge(taxpayer_organisation_fao: '') }
      it { expect(subject.taxpayer_name?).to eq(false) }
    end
  end
end
