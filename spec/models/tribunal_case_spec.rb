require 'rails_helper'

RSpec.describe TribunalCase, type: :model do
  describe '.case_type_values' do
    it 'gets values from the CaseType' do
      expect(CaseType).to receive(:values).and_return(['foo'])
      expect(described_class.case_type_values).to eq(['foo'])
    end
  end
end
