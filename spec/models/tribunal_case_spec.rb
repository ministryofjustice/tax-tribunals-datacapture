require 'rails_helper'

RSpec.describe TribunalCase, type: :model do
  describe '.what_is_appeal_about_values' do
    it 'matches TribunalCase::WHAT_IS_APPEAL_ABOUT_VALUES' do
      expect(described_class.what_is_appeal_about_values).to eq(described_class::WHAT_IS_APPEAL_ABOUT_VALUES)
    end
  end
end
