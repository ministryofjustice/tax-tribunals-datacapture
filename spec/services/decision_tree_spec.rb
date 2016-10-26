require 'rails_helper'

RSpec.describe DecisionTree do
  let(:object)    { double('Object') }
  let(:step)      { double('Step') }
  let(:next_step) { nil }
  subject { described_class.new(object: object, step: step, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `did_challenge_hmrc`' do
      context 'and the answer is yes' do
        let(:step) { { did_challenge_hmrc: 'yes' } }

        it 'sends the user to the `appeal_cost` endpoint' do
          expect(Rails.application).to receive_message_chain(:routes, :url_helpers, :decision_path).with('appeal_cost').and_return('/expected_endpoint')
          expect(subject.destination).to eq('/expected_endpoint')
        end
      end

      context 'and the answer is no' do
        let(:step) { { did_challenge_hmrc: 'no' } }

        it 'sends the user to the `must_challenge_hmrc` endpoint' do
          expect(Rails.application).to receive_message_chain(:routes, :url_helpers, :decision_path).with('must_challenge_hmrc').and_return('/expected_endpoint')
          expect(subject.destination).to eq('/expected_endpoint')
        end
      end
    end

    context 'when the step is invalid' do
      let(:step) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.destination }.to raise_error(RuntimeError)
      end
    end
  end
end
