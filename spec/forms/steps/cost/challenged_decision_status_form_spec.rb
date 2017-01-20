require 'spec_helper'

RSpec.describe Steps::Cost::ChallengedDecisionStatusForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    challenged_decision_status: challenged_decision_status
  } }
  let(:tribunal_case) { instance_double(TribunalCase, challenged_decision_status: nil) }
  let(:challenged_decision_status) { nil }

  subject { described_class.new(arguments) }

  pending 'Write specs for ChallengedDecisionStatusForm!'

  # TODO: The below can be uncommented and serves as a starting point for
  #   forms operating on a single value object.

  # describe '#save' do
  #   context 'when no tribunal_case is associated with the form' do
  #     let(:tribunal_case)  { nil }
  #     let(:challenged_decision_status) { 'value' }

  #     it 'raises an error' do
  #       expect { subject.save }.to raise_error(RuntimeError)
  #     end
  #   end

  #   context 'when challenged_decision_status is not given' do
  #     it 'returns false' do
  #       expect(subject.save).to be(false)
  #     end

  #     it 'has a validation error on the field' do
  #       expect(subject).to_not be_valid
  #       expect(subject.errors[:challenged_decision_status]).to_not be_empty
  #     end
  #   end

  #   context 'when challenged_decision_status is not valid' do
  #     let(:challenged_decision_status) { 'INVALID VALUE' }

  #     it 'returns false' do
  #       expect(subject.save).to be(false)
  #     end

  #     it 'has a validation error on the field' do
  #       expect(subject).to_not be_valid
  #       expect(subject.errors[:challenged_decision_status]).to_not be_empty
  #     end
  #   end

  #   context 'when challenged_decision_status is valid' do
  #     let(:challenged_decision_status) { 'INSERT VALID VALUE HERE' }

  #     it 'saves the record' do
  #       expect(tribunal_case).to receive(:update).with(
  #         # TODO: What's in the update?
  #       ).and_return(true)
  #       expect(subject.save).to be(true)
  #     end
  #   end

  #   context 'when challenged_decision_status is already the same on the model' do
  #     let(:tribunal_case) {
  #       instance_double(
  #         TribunalCase,
  #         challenged_decision_status: 'INSERT EXISTING VALUE HERE'
  #       )
  #     }
  #     let(:challenged_decision_status) { 'CHANGEME' }

  #     it 'does not save the record but returns true' do
  #       expect(tribunal_case).to_not receive(:update)
  #       expect(subject.save).to be(true)
  #     end
  #   end
  # end
end

