require 'spec_helper'

RSpec.describe Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Form do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    <%= step_name.underscore %>: <%= step_name.underscore %>
  } }
  let(:tribunal_case) { instance_double(TribunalCase, <%= step_name.underscore %>: nil) }
  let(:<%= step_name.underscore %>) { nil }

  subject { described_class.new(arguments) }

  pending 'Write specs for <%= step_name.camelize %>Form!'

  # TODO: The below can be uncommented and serves as a starting point for
  #   forms operating on a single value object.

  # describe '#save' do
  #   context 'when no tribunal_case is associated with the form' do
  #     let(:tribunal_case)  { nil }
  #     let(:<%= step_name.underscore %>) { 'value' }

  #     it 'raises an error' do
  #       expect { subject.save }.to raise_error(RuntimeError)
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is not given' do
  #     it 'returns false' do
  #       expect(subject.save).to be(false)
  #     end

  #     it 'has a validation error on the field' do
  #       expect(subject).to_not be_valid
  #       expect(subject.errors[:<%= step_name.underscore %>]).to_not be_empty
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is not valid' do
  #     let(:<%= step_name.underscore %>) { 'INVALID VALUE' }

  #     it 'returns false' do
  #       expect(subject.save).to be(false)
  #     end

  #     it 'has a validation error on the field' do
  #       expect(subject).to_not be_valid
  #       expect(subject.errors[:<%= step_name.underscore %>]).to_not be_empty
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is valid' do
  #     let(:<%= step_name.underscore %>) { 'INSERT VALID VALUE HERE' }

  #     it 'saves the record' do
  #       expect(tribunal_case).to receive(:update).with(
  #         # TODO: What's in the update?
  #       ).and_return(true)
  #       expect(subject.save).to be(true)
  #     end
  #   end

  #   context 'when <%= step_name.underscore %> is already the same on the model' do
  #     let(:tribunal_case) {
  #       instance_double(
  #         TribunalCase,
  #         <%= step_name.underscore %>: 'INSERT EXISTING VALUE HERE'
  #       )
  #     }
  #     let(:<%= step_name.underscore %>) { 'CHANGEME' }

  #     it 'does not save the record but returns true' do
  #       expect(tribunal_case).to_not receive(:update)
  #       expect(subject.save).to be(true)
  #     end
  #   end
  # end
end

