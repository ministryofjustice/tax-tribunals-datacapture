require 'spec_helper'

RSpec.describe Steps::Lateness::LatenessReasonForm do
  let(:arguments) { {
    tribunal_case:   tribunal_case,
    lateness_reason: lateness_reason
  } }
  let(:tribunal_case)   { instance_double(TribunalCase, lateness_reason: nil, in_time: in_time) }
  let(:lateness_reason) { nil }
  let(:in_time)         { nil }

  subject { described_class.new(arguments) }

  describe '#lateness_unknown?' do
    context 'when appeal is not late' do
      let(:in_time) { InTime::YES }

      it 'should return false' do
        expect(subject.lateness_unknown?).to be(false)
      end
    end

    context 'when appeal is late' do
      let(:in_time) { InTime::NO }

      it 'should return false' do
        expect(subject.lateness_unknown?).to be(false)
      end
    end

    context 'when appellant is not sure' do
      let(:in_time) { InTime::UNSURE }

      it 'should return false' do
        expect(subject.lateness_unknown?).to be(true)
      end
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:lateness_reason) { 'I am a gummy bear' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when lateness_reason is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:lateness_reason]).to_not be_empty
      end
    end

    context 'when lateness_reason is too short' do
      let(:lateness_reason) { 'meh' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:lateness_reason]).to_not be_empty
      end
    end

    context 'when lateness_reason is valid' do
      let(:lateness_reason) { 'Forgive me, dear judge' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          lateness_reason: lateness_reason
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
