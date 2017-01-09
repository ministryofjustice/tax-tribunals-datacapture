require 'spec_helper'

RSpec.describe GlimrFees do
  describe '.lodgement_fee_amount' do
    let(:tribunal_case) { instance_double(TribunalCase, mapping_code: mapping_code) }
    subject { described_class.lodgement_fee_amount(tribunal_case) }

    context 'with mapping code appl_penalty_low' do
      let(:mapping_code) { MappingCode::APPL_PENALTY_LOW }

      it { is_expected.to eq(20_00) }
    end

    context 'with mapping code appl_penalty_med' do
      let(:mapping_code) { MappingCode::APPL_PENALTY_MED }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appl_penalty_high' do
      let(:mapping_code) { MappingCode::APPL_PENALTY_HIGH }

      it { is_expected.to eq(200_00) }
    end

    context 'with mapping code appl_payecoding' do
      let(:mapping_code) { MappingCode::APPL_PAYECODING }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appl_infonotice' do
      let(:mapping_code) { MappingCode::APPL_INFONOTICE }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appl_other' do
      let(:mapping_code) { MappingCode::APPL_OTHER }

      it { is_expected.to eq(200_00) }
    end

    context 'with mapping code appn_closeenquiry' do
      let(:mapping_code) { MappingCode::APPN_CLOSEENQUIRY }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appn_other' do
      let(:mapping_code) { MappingCode::APPN_OTHER }

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
