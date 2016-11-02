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

        it 'sends the user to the what_is_appeal_about_unchallenged step' do
          expect(subject.destination).to eq({
            controller: :what_is_appeal_about_unchallenged,
            action:     :edit
          })
        end
      end
    end

    context 'when the step is `what_is_appeal_about_challenged`' do
      context 'and the answer is `vat`' do
        let(:step) { { what_is_appeal_about_challenged: 'vat' } }

        it 'sends the user to the what_is_dispute_about_vat step' do
          expect(subject.destination).to eq({
            controller: :what_is_dispute_about_vat,
            action:     :edit
          })
        end
      end

      context 'and the answer is `income_tax`' do
        let(:step) { { what_is_appeal_about_challenged: 'income_tax' } }

        it 'sends the user to the what_is_dispute_about_income_tax step' do
          expect(subject.destination).to eq({
            controller: :what_is_dispute_about_income_tax,
            action:     :edit
          })
        end
      end

      context 'and the answer is anything else' do
        let(:step) { { what_is_appeal_about_challenged: 'anything_for_now' } }

        it 'sends the user to the endpoint' do
          expect(subject.destination).to eq({
            controller: :determine_cost,
            action:     :show
          })
        end
      end
    end

    context 'when the step is `what_is_appeal_about_unchallenged`' do
      context 'and the answer is `income_tax`' do
        let(:step) { { what_is_appeal_about_unchallenged: 'income_tax' } }

        it 'sends the user to the `must_challenge_hmrc` endpoint' do
          expect(subject.destination).to eq({
            controller: :must_challenge_hmrc,
            action:     :show
          })
        end
      end

      context 'and the answer is `vat`' do
        let(:step) { { what_is_appeal_about_unchallenged: 'vat' } }

        it 'sends the user to the `what_is_dispute_about_vat` endpoint' do
          expect(subject.destination).to eq({
            controller: :what_is_dispute_about_vat,
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
          let(:step) { { what_is_appeal_about_unchallenged: tax_type } }

          it 'sends the user to the `determine_cost` endpoint' do
            expect(subject.destination).to eq({
              controller: :determine_cost,
              action:     :show
            })
          end
        end
      end
    end

    context 'when the step is `what_is_dispute_about_income_tax`' do
      context 'and the answer is `amount_of_tax_owed`' do
        let(:step) { { what_is_dispute_about_income_tax: 'amount_of_tax_owed' } }

        it 'sends the user to the `determine_cost` endpoint' do
          expect(subject.destination).to eq({
            controller: :determine_cost,
            action:     :show
          })
        end
      end

      context 'and the answer is `paye_coding_notice`' do
        let(:step) { { what_is_dispute_about_income_tax: 'paye_coding_notice' } }

        it 'sends the user to the `determine_cost` endpoint' do
          expect(subject.destination).to eq({
            controller: :determine_cost,
            action:     :show
          })
        end
      end

      context 'and the answer is `late_return_or_payment`' do
        let(:step) { { what_is_dispute_about_income_tax: 'late_return_or_payment' } }

        it 'sends the user to the `what_is_late_penalty_or_surcharge` step' do
          expect(subject.destination).to eq({
            controller: :what_is_late_penalty_or_surcharge,
            action:     :edit
          })
        end
      end
    end

    context 'when the step is `what_is_dispute_about_vat`' do
      context 'and the answer is `amount_of_tax_owed`' do
        let(:step) { { what_is_dispute_about_vat: 'amount_of_tax_owed' } }

        it 'sends the user to the `determine_cost` endpoint' do
          expect(subject.destination).to eq({
            controller: :determine_cost,
            action:     :show
          })
        end
      end

      context 'and the answer is `late_return_or_payment`' do
        let(:step) { { what_is_dispute_about_vat: 'late_return_or_payment' } }

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
