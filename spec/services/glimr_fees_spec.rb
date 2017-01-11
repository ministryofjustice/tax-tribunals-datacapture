require 'spec_helper'

RSpec.describe GlimrFees do
  describe '.lodgement_fee_amount' do
    let(:tribunal_case) { instance_double(TribunalCase, mapping_code: mapping_code) }
    subject { described_class.lodgement_fee_amount(tribunal_case) }

    context 'with mapping code appeal_payecoding' do
      let(:mapping_code) { MappingCode::APPEAL_PAYECODING }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appeal_infonotice' do
      let(:mapping_code) { MappingCode::APPEAL_INFONOTICE }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appeal_penalty_low' do
      let(:mapping_code) { MappingCode::APPEAL_PENALTY_LOW }

      it { is_expected.to eq(20_00) }
    end

    context 'with mapping code appeal_penalty_med' do
      let(:mapping_code) { MappingCode::APPEAL_PENALTY_MED }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appeal_penalty_high' do
      let(:mapping_code) { MappingCode::APPEAL_PENALTY_HIGH }

      it { is_expected.to eq(200_00) }
    end

    context 'with mapping code appeal_other' do
      let(:mapping_code) { MappingCode::APPEAL_OTHER }

      it { is_expected.to eq(200_00) }
    end

    context 'with mapping code appn_decision_enqry' do
      let(:mapping_code) { MappingCode::APPN_DECISION_ENQRY }

      it { is_expected.to eq(50_00) }
    end

    context 'with mapping code appn_late' do
      let(:mapping_code) { MappingCode::APPN_LATE }

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
