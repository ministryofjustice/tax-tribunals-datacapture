RSpec.describe SendApplicationDetails do
  subject { described_class.new(value) }

  describe '#values' do
    it 'has value email' do
      expect(SendApplicationDetails.values[0].to_s).to eq('email')
    end
    it 'has value text' do
      expect(SendApplicationDetails.values[1].to_s).to eq('text')
    end
    it 'has value both' do
      expect(SendApplicationDetails.values[2].to_s).to eq('both')
    end
    it 'has value none' do
      expect(SendApplicationDetails.values[3].to_s).to eq('none')
    end
  end
end
