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

        it 'sends the user to the what_is_appeal_about_challenged step' do
          expect(subject.destination).to eq({
            controller: :what_is_appeal_about_challenged,
            action:     :edit
          })
        end
      end

      context 'and the answer is no' do
        let(:step) { { did_challenge_hmrc: 'no' } }

        it 'sends the user to the endpoint' do
          expect(subject.destination).to eq({
            controller: :what_is_appeal_about_unchallenged,
            action:     :edit
          })
        end
      end
    end

    context 'when the step is `what_is_appeal_about_challenged`' do
      let(:step) { { what_is_appeal_about_challenged: 'anything_for_now' } }

      it 'sends the user to the endpoint' do
        expect(subject.destination).to eq({
          controller: :determine_cost,
          action:     :show
        })
      end
    end

    context 'when the step is `what_is_appeal_about_unchallenged`' do
      let(:step) { { what_is_appeal_about_unchallenged: 'anything_for_now' } }

      it 'sends the user to the endpoint' do
        expect(subject.destination).to eq({
          controller: :determine_cost,
          action:     :show
        })
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
