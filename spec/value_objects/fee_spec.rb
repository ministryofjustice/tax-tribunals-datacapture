require 'rails_helper'

RSpec.describe Fee do
  let(:amount) { 123 }
  subject      { described_class.new(amount) }

  it 'is immutable' do
    expect(subject).to be_frozen
  end

  it 'does not accept values that are not implicitly convertible to integers' do
    expect { described_class.new('ALL THE MONEYS') }.to raise_error(ArgumentError)
  end

  describe '#value' do
    it 'returns the stored value' do
      expect(subject.value).to eq(123)
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the fee' do
      expect(subject.to_s).to eq('123')
    end
  end

  describe '#to_gbp' do
    it 'returns a float representation of the fee in GBP' do
      expect(subject.to_gbp).to eq(1.23)
    end
  end

  describe '#==' do
    context 'when comparing to an equal Fee' do
      let(:other) { described_class.new(amount) }

      it 'returns true' do
        expect(subject).to eq(other)
      end
    end

    context 'when comparing to a different fee' do
      let(:other) { described_class.new(321) }

      it 'returns false' do
        expect(subject).to_not eq(other)
      end
    end

    context 'when comparing to a different class' do
      let(:other) { 123 }

      it 'returns false' do
        expect(subject).to_not eq(other)
      end
    end
  end
end
