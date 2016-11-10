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

        it 'sends the user to the case_type_challenged step' do
          expect(subject.destination).to eq({
            controller: :case_type_challenged,
            action:     :edit
          })
        end
      end

      context 'and the answer is no' do
        let(:step) { { did_challenge_hmrc: 'no' } }

        it 'sends the user to the case_type_unchallenged step' do
          expect(subject.destination).to eq({
            controller: :case_type_unchallenged,
            action:     :edit
          })
        end
      end
    end

    context 'when the step is `case_type_challenged`' do
      context 'and the answer is `vat`' do
        let(:step) { { case_type_challenged: 'vat' } }

        it 'sends the user to the dispute_type step' do
          expect(subject.destination).to eq({
            controller: :dispute_type,
            action:     :edit
          })
        end
      end

      context 'and the answer is `income_tax`' do
        let(:step) { { case_type_challenged: 'income_tax' } }

        it 'sends the user to the dispute_type step' do
          expect(subject.destination).to eq({
            controller: :dispute_type,
            action:     :edit
          })
        end
      end

      context 'and the answer is anything else' do
        let(:step) { { case_type_challenged: 'anything_for_now' } }

        it 'sends the user to the endpoint' do
          expect(subject.destination).to eq({
            controller: :determine_cost,
            action:     :show
          })
        end
      end
    end

    context 'when the step is `case_type_unchallenged`' do
      context 'and the answer is `income_tax`' do
        let(:step) { { case_type_unchallenged: 'income_tax' } }

        it 'sends the user to the `must_challenge_hmrc` endpoint' do
          expect(subject.destination).to eq({
            controller: :must_challenge_hmrc,
            action:     :show
          })
        end
      end

      context 'and the answer is `vat`' do
        let(:step) { { case_type_unchallenged: 'vat' } }

        it 'sends the user to the `dispute_type` endpoint' do
          expect(subject.destination).to eq({
            controller: :dispute_type,
            action:     :edit
          })
        end
      end

      %w(
        apn_penalty
        inaccurate_return
        closure_notice
        information_notice
        request_permission_for_review
        other
      ).each do |tax_type|
        context "and the answer is `#{tax_type}`" do
          let(:step) { { case_type_unchallenged: tax_type } }

          it 'sends the user to the `determine_cost` endpoint' do
            expect(subject.destination).to eq({
              controller: :determine_cost,
              action:     :show
            })
          end
        end
      end
    end

    context 'when the step is `dispute_type`' do
      context 'and the answer is `amount_of_tax_owed`' do
        let(:step) { { dispute_type: 'amount_of_tax_owed' } }

        it 'sends the user to the `determine_cost` endpoint' do
          expect(subject.destination).to eq({
            controller: :determine_cost,
            action:     :show
          })
        end
      end

      context 'and the answer is `paye_coding_notice`' do
        let(:step) { { dispute_type: 'paye_coding_notice' } }

        it 'sends the user to the `determine_cost` endpoint' do
          expect(subject.destination).to eq({
            controller: :determine_cost,
            action:     :show
          })
        end
      end

      context 'and the answer is `late_return_or_payment`' do
        let(:step) { { dispute_type: 'late_return_or_payment' } }

        it 'sends the user to the `what_is_late_penalty_or_surcharge` step' do
          expect(subject.destination).to eq({
            controller: :what_is_late_penalty_or_surcharge,
            action:     :edit
          })
        end
      end
    end

    context 'when the step is `what_is_late_penalty_or_surcharge`' do
      let(:step) { { what_is_late_penalty_or_surcharge: 'anything' } }

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
