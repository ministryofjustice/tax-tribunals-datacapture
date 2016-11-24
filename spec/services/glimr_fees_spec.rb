require 'spec_helper'

RSpec.describe GlimrFees do
  describe '.fee_amount' do
    subject { described_class.fee_amount(fee) }

    context 'with lodgement fee level 1' do
      let(:fee) { LodgementFee::FEE_LEVEL_1 }

      it { is_expected.to eq(20_00) }
    end

    context 'with lodgement fee level 2' do
      let(:fee) { LodgementFee::FEE_LEVEL_2 }

      it { is_expected.to eq(50_00) }
    end

    context 'with lodgement fee level 3' do
      let(:fee) { LodgementFee::FEE_LEVEL_3 }

      it { is_expected.to eq(200_00) }
    end

    context 'with an unexpected argument' do
      let(:fee) { LodgementFee.new(:foo_bar) }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
