require 'spec_helper'

RSpec.describe TribunalCase, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe '#lodgement_fee' do
    it 'queries GlimrFees for the amount' do
      expect(GlimrFees).to receive(:lodgement_fee_amount).with(subject).and_return(9999)
      expect(subject.lodgement_fee).to eq(9999)
    end
  end

  describe '#mapping_code' do
    let(:mapping_code) { MappingCode.new(:hmrc_stole_my_cookies) }
    let(:determiner) { instance_double(MappingCodeDeterminer, mapping_code: mapping_code) }

    it 'queries MappingCodeDeterminer for the mapping code' do
      expect(MappingCodeDeterminer).to receive(:new).with(subject).and_return(determiner)
      expect(subject.mapping_code).to eq(mapping_code)
    end
  end

  describe '#cost_task_completed?' do
    before do
      allow(MappingCodeDeterminer).to receive(:new).with(subject).and_return(determiner)
    end

    context 'when a mapping code can be determined' do
      let(:determiner) { instance_double(MappingCodeDeterminer, valid_for_determining_mapping_code?: true) }

      it 'returns true' do
        expect(subject.cost_task_completed?).to eq(true)
      end
    end

    context 'when no mapping code can be determined yet' do
      let(:determiner) { instance_double(MappingCodeDeterminer, valid_for_determining_mapping_code?: false) }

      it 'returns false' do
        expect(subject.cost_task_completed?).to eq(false)
      end
    end
  end

  describe '#lateness_task_completed?' do
    let(:attributes) { {
      in_time:         in_time,
      lateness_reason: lateness_reason
    } }
    let(:in_time)         { nil }
    let(:lateness_reason) { nil }

    before do
      allow(MappingCodeDeterminer).to receive(:new).and_return(determiner)
    end

    context 'when a lodgement fee has been determined' do
      let(:determiner) { instance_double(MappingCodeDeterminer, valid_for_determining_mapping_code?: true) }

      context 'when there is no in_time value' do
        let(:in_time) { nil }

        it 'returns false' do
          expect(subject.lateness_task_completed?).to eq(false)
        end

        context 'even when a lateness reason exists' do
          let(:lateness_reason) { 'I can never happen' }

          it 'still returns false' do
            expect(subject.lateness_task_completed?).to eq(false)
          end
        end
      end

      context 'when the appeal is in time' do
        let(:in_time) { InTime.new(:yes) }

        it 'returns true' do
          expect(subject.lateness_task_completed?).to eq(true)
        end
      end

      context 'when the appeal is late' do
        let(:in_time) { InTime.new(:no) }

        context 'and there is a reason given' do
          let(:lateness_reason) { 'Sorry' }

          it 'returns true' do
            expect(subject.lateness_task_completed?).to eq(true)
          end
        end

        context 'and there is no reason given' do
          let(:lateness_reason) { nil }

          it 'returns false' do
            expect(subject.lateness_task_completed?).to eq(false)
          end
        end
      end

      context 'when the appeal lateness is unsure' do
        let(:in_time) { InTime.new(:unsure) }

        context 'and there is a reason given' do
          let(:lateness_reason) { 'Sorry' }

          it 'returns true' do
            expect(subject.lateness_task_completed?).to eq(true)
          end
        end

        context 'and there is no reason given' do
          let(:lateness_reason) { nil }

          it 'returns false' do
            expect(subject.lateness_task_completed?).to eq(false)
          end
        end
      end
    end

    context 'when no lodgement fee has been determined yet' do
      let(:determiner) { instance_double(MappingCodeDeterminer, valid_for_determining_mapping_code?: false) }

      it 'returns false' do
        expect(subject.lateness_task_completed?).to eq(false)
      end

      context 'even when a later step has been completed' do
        let(:in_time) { InTime.new(:yes) }

        it 'still returns false' do
          expect(subject.lateness_task_completed?).to eq(false)
        end
      end
    end
  end

  describe '#default_documents_filter' do
    let(:attributes) { {grounds_for_appeal_file_name: 'test.doc'} }

    it 'defaults to grounds_for_appeal_file_name' do
      expect(subject.default_documents_filter).to eq(['test.doc'])
    end
  end

  describe '#documents' do
    let(:collection_ref) { SecureRandom.uuid }
    let(:attributes) { {files_collection_ref: collection_ref, grounds_for_appeal_file_name: 'test.doc'} }

    context 'with default filtering' do
      it 'should return the uploaded documents for this tribunal case' do
        expect(Document).to receive(:for_collection).with(collection_ref, filter: ['test.doc'])
        subject.documents
      end
    end
  end

  describe '#company?' do
    context 'when taxpayer is a company' do
      let(:attributes) { {taxpayer_type: TaxpayerType::COMPANY} }

      it 'returns true' do
        expect(subject.taxpayer_is_company?).to eq(true)
      end
    end

    context 'when taxpayer is an individual' do
      let(:attributes) { {taxpayer_type: TaxpayerType::INDIVIDUAL} }

      it 'returns false' do
        expect(subject.taxpayer_is_company?).to eq(false)
      end
    end
  end
end
