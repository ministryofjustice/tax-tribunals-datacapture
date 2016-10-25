require 'rails_helper'

RSpec.describe DidChallengeHmrcForm do
  let(:arguments) { {
    tribunal_case:      tribunal_case,
    did_challenge_hmrc: did_challenge_hmrc
  } }
  let(:tribunal_case)      { instance_double(TribunalCase, did_challenge_hmrc: nil) }
  let(:did_challenge_hmrc) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:did_challenge_hmrc) { true }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when did_challenge_hmrc is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:did_challenge_hmrc]).to_not be_empty
      end
    end

    context 'when did_challenge_hmrc is not valid' do
      let(:did_challenge_hmrc) { 'wibble' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:did_challenge_hmrc]).to_not be_empty
      end
    end

    context 'when did_challenge_hmrc is valid' do
      let(:did_challenge_hmrc) { true }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with( did_challenge_hmrc: true)
        expect(subject.save).to be(true)
      end
    end
  end
end
