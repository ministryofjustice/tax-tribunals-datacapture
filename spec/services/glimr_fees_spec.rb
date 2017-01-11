require 'spec_helper'

RSpec.describe GlimrFees do
  describe '.lodgement_fee_amount' do
    let(:tribunal_case) { instance_double(TribunalCase, mapping_code: mapping_code) }
    subject { described_class.lodgement_fee_amount(tribunal_case) }

    context 'with mapping code taxpenaltylow' do
      let(:mapping_code) { MappingCode::TAXPENALTYLOW }

      it { is_expected.to eq(20_00) }
    end

    context 'with mapping code taxpenaltymed' do
      let(:mapping_code) { MappingCode::TAXPENALTYMED }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code payecoding' do
      let(:mapping_code) { MappingCode::PAYECODING }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appntoclose' do
      let(:mapping_code) { MappingCode::APPNTOCLOSE }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code taxpenaltyhigh' do
      let(:mapping_code) { MappingCode::TAXPENALTYHIGH }

      it { is_expected.to eq(200_00) }
    end

    context 'with mapping code otherappeal' do
      let(:mapping_code) { MappingCode::OTHERAPPEAL }

      it { is_expected.to eq(200_00) }
    end

    context 'with mapping code otherapplication' do
      let(:mapping_code) { MappingCode::OTHERAPPLICATION }

      it { is_expected.to eq(200_00) }
    end

    context 'with an unexpected argument' do
      let(:mapping_code) { MappingCode.new(:xyzy_zzzzzz) }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
