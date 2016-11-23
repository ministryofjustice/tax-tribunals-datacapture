require 'spec_helper'

RSpec.describe InTimeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    in_time:       in_time
  } }
  let(:tribunal_case) { instance_double(TribunalCase, in_time: nil) }
  let(:in_time)       { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:in_time) { 'yes' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when in_time is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:in_time]).to_not be_empty
      end
    end

    context 'when in_time is not valid' do
      let(:in_time) { 'like, totally not' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:in_time]).to_not be_empty
      end
    end

    context 'when in_time is valid' do
      let(:in_time) { 'unsure' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          in_time:         InTime::UNSURE,
          lateness_reason: nil
        )
        expect(subject.save).to be(true)
      end
    end

    context 'when in_time is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          in_time: InTime::YES
        )
      }
      let(:in_time) { 'yes' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
