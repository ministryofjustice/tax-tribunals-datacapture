RSpec.describe SendApplicationDetails do
  subject { described_class.new(value) }

  describe '#values' do
    it 'has value yes' do
      expect(SendApplicationDetails.values.first.to_s).to eq('yes')
    end

    it 'has value no' do
      expect(SendApplicationDetails.values.last.to_s).to eq('no')
    end
  end
end
