require 'spec_helper'

RSpec.describe Steps::Challenge::DecisionStatusForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    challenged_decision_status: challenged_decision_status
  } }
  let(:tribunal_case) { instance_double(TribunalCase, case_type: case_type, challenged_decision_status: nil) }
  let(:challenged_decision_status) { nil }
  let(:case_type) { CaseType::CORPORATION_TAX }

  subject { described_class.new(arguments) }

  describe '#choices' do
    context 'when the case type is a direct tax' do
      let(:case_type) { CaseType::INCOME_TAX }

      it 'shows only the relevant choices' do
        expect(subject.choices).to  match_array([
          ChallengedDecisionStatus::RECEIVED,
          ChallengedDecisionStatus::PENDING,
          ChallengedDecisionStatus::OVERDUE,
          ChallengedDecisionStatus::NOT_REQUIRED,
          ChallengedDecisionStatus::APPEAL_LATE_REJECTION,
          ChallengedDecisionStatus::APPEALING_DIRECTLY
        ])
      end
    end

    context 'when the case type is restoration case' do
      let(:case_type) { CaseType::RESTORATION_CASE }

      it 'shows only the relevant choices' do
        expect(subject.choices).to match_array([
          ChallengedDecisionStatus::RECEIVED,
          ChallengedDecisionStatus::PENDING,
          ChallengedDecisionStatus::OVERDUE,
          ChallengedDecisionStatus::REVIEW_LATE_REJECTION
        ])
      end
    end

    context 'when the case type is any other' do
      let(:case_type) { CaseType::VAT }

      it 'shows only the relevant choices' do
        expect(subject.choices).to match_array([
          ChallengedDecisionStatus::RECEIVED,
          ChallengedDecisionStatus::PENDING,
          ChallengedDecisionStatus::OVERDUE,
          ChallengedDecisionStatus::REFUSED
        ])
      end
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:challenged_decision_status) { ChallengedDecisionStatus::RECEIVED }

      specify do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when challenged_decision_status is not given' do
      it 'does not save' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:challenged_decision_status]).to_not be_empty
      end
    end

    context 'direct tax case types' do
      let(:case_type) { CaseType::CORPORATION_TAX }

      context 'when challenged_decision_status is not valid' do
        let(:challenged_decision_status) { 'refused' }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:challenged_decision_status]).to_not be_empty
        end
      end

      context 'when challenged_decision_status is valid' do
        let(:challenged_decision_status) { 'not_required' }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
              challenged_decision_status: ChallengedDecisionStatus::NOT_REQUIRED
          ).and_return(true)
          expect(subject.save).to be(true)
        end
      end
    end

    context 'other than direct tax case types' do
      let(:case_type) { CaseType::VAT }

      context 'when challenged_decision_status is not valid' do
        let(:challenged_decision_status) { 'not_required' }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:challenged_decision_status]).to_not be_empty
        end
      end

      context 'when challenged_decision_status is valid' do
        let(:challenged_decision_status) { 'refused' }

        it 'saves the record' do
          expect(tribunal_case).to receive(:update).with(
              challenged_decision_status: ChallengedDecisionStatus::REFUSED
          ).and_return(true)
          expect(subject.save).to be(true)
        end
      end
    end

    context 'when challenged_decision_status is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          case_type: case_type,
          challenged_decision_status: ChallengedDecisionStatus::PENDING
        )
      }
      let(:challenged_decision_status) { 'pending' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).not_to receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
