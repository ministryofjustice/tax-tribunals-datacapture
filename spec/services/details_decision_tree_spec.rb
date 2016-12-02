require 'spec_helper'

RSpec.describe DetailsDecisionTree do
  let(:object)    { double('Object') }
  let(:step)      { double('Step') }
  let(:next_step) { nil }
  subject { described_class.new(object: object, step: step, next_step: next_step) }

  describe '#destination' do
    context 'when the step is `taxpayer_type`' do
      context 'and the answer is `individual`' do
        let(:step) { { taxpayer_type: 'individual'  } }

        it 'sends the user to the `individual_details` step' do
          expect(subject.destination).to eq({
            controller: :individual_details,
            action:     :edit
          })
        end
      end

      context 'and the answer is `company`' do
        let(:step) { { taxpayer_type: 'company'  } }

        it 'sends the user to the `company_details` step' do
          expect(subject.destination).to eq({
            controller: :company_details,
            action:     :edit
          })
        end
      end
    end

    context 'when the step is `individual_details`' do
      let(:step) { { individual_details: 'anything'  } }

      it 'sends the user to the task list' do
        expect(subject.destination).to eq({
          controller: '/home',
          action:     :index
        })
      end
    end

    context 'when the step is `company_details`' do
      let(:step) { { company_details: 'anything'  } }

      it 'sends the user to the task list' do
        expect(subject.destination).to eq({
          controller: '/home',
          action:     :index
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

  describe '#previous' do
    context 'when the step is `taxpayer_type`' do
      let(:step) { { taxpayer_type: 'anything'  } }

      it 'sends the user to `start` step' do
        expect(subject.previous).to eq({
          controller: :start,
          action:     :show
        })
      end
    end

    context 'when the step is `individual_details`' do
      let(:step) { { individual_details: 'anything'  } }

      it 'sends the user to `taxpayer_type` step' do
        expect(subject.previous).to eq({
          controller: :taxpayer_type,
          action:     :edit
        })
      end
    end

    context 'when the step is `company_details`' do
      let(:step) { { company_details: 'anything'  } }

      it 'sends the user to `taxpayer_type` step' do
        expect(subject.previous).to eq({
          controller: :taxpayer_type,
          action:     :edit
        })
      end
    end

    context 'when the step is invalid' do
      let(:step) { { ungueltig: { waschmaschine: 'nein' } } }

      it 'raises an error' do
        expect { subject.previous }.to raise_error(RuntimeError)
      end
    end
  end
end
