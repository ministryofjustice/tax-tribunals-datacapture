require 'spec_helper'

RSpec.describe TribunalCase, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe '#cost_task_completed?' do
    let(:attributes) { { lodgement_fee: lodgement_fee } }

    context 'when a lodgement fee has been determined' do
      let(:lodgement_fee) { LodgementFee::FEE_LEVEL_1 }

      it 'returns true' do
        expect(subject.cost_task_completed?).to eq(true)
      end
    end

    context 'when no lodgement fee has been determined yet' do
      let(:lodgement_fee) { nil }

      it 'returns false' do
        expect(subject.cost_task_completed?).to eq(false)
      end
    end
  end

  describe '#lateness_task_completed?' do
    let(:attributes) { {
      lodgement_fee:   lodgement_fee,
      in_time:         in_time,
      lateness_reason: lateness_reason
    } }
    let(:in_time)         { nil }
    let(:lateness_reason) { nil }

    context 'when a lodgement fee has been determined' do
      let(:lodgement_fee) { LodgementFee::FEE_LEVEL_1 }

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
      let(:lodgement_fee) { nil }

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
end
