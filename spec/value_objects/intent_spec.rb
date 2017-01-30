require 'spec_helper'

RSpec.describe Intent do
  let(:intent) { :foo }

  subject { described_class.new(intent) }

  describe '.values' do
    it 'returns all available intents' do
      expect(described_class.values.map(&:to_s)).to match_array(%w(tax_appeal close_enquiry))
    end
  end
end
