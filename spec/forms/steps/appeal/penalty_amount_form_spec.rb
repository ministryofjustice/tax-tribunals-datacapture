require 'spec_helper'

RSpec.describe Steps::Appeal::PenaltyAmountForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    penalty_level: penalty_level,
    penalty_amount: penalty_amount
  } }
  let(:tribunal_case) { instance_double(TribunalCase, penalty_level: nil, penalty_amount: nil) }
  let(:penalty_level)  { nil }
  let(:penalty_amount) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:penalty_level) { 'penalty_level_1' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when penalty_level is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:penalty_level]).to_not be_empty
      end
    end

    context 'when penalty_level is not valid' do
      let(:penalty_level) { 'loads-of-$$$' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:penalty_level]).to_not be_empty
      end
    end

    context 'when penalty_level is valid' do
      let(:penalty_level) { 'penalty_level_1' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          penalty_level: PenaltyLevel::PENALTY_LEVEL_1,
          penalty_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end

      context 'when penalty amount is required' do
        let(:penalty_level) { 'penalty_level_2' }

        context 'when penalty amount is not supplied' do
          it 'returns false' do
            expect(subject.save).to be(false)
          end

          it 'has a validation error on the field' do
            expect(subject).to_not be_valid
            expect(subject.errors[:penalty_amount]).to_not be_empty
          end
        end

        context 'when penalty amount supplied is at lower bound or below' do
          let(:penalty_amount) {'100'}

          it 'does not save the record' do
            expect(subject.save).to be(false)
          end
        end

        context 'when penalty amount supplied is at lower bound or below' do
          let(:penalty_amount) {'20001'}

          it 'does not save the record' do
            expect(subject.save).to be(false)
          end
        end
        
        context 'when penalty amount supplied is in valid range' do
          let(:penalty_amount) {'10000'}

          it 'saves the record' do
            expect(tribunal_case).to receive(:update).with(
                                       penalty_level: PenaltyLevel::PENALTY_LEVEL_2,
                                       penalty_amount: '10000'
                                     ).and_return(true)
            expect(subject.save).to be(true)
          end
        end

        context 'when penalty amount supplied is unknown' do
          let(:penalty_amount) {'unknown'}

          it 'saves the record' do
            expect(tribunal_case).to receive(:update).with(
              penalty_level: PenaltyLevel::PENALTY_LEVEL_2,
              penalty_amount: 'unknown'
            ).and_return(true)
            expect(subject.save).to be(true)
          end
        end
      end
    end
  end
end
