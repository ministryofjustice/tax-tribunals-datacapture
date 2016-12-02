require 'spec_helper'

RSpec.describe Steps::Details::GroundsForAppealForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    grounds_for_appeal: grounds_for_appeal
  } }
  let(:tribunal_case) { instance_double(TribunalCase, grounds_for_appeal: nil) }
  let(:grounds_for_appeal) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:grounds_for_appeal) { 'value' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when grounds_for_appeal is not given' do
      pending 'decide what validations we have'
      # it 'returns false' do
      #   expect(subject.save).to be(false)
      # end
      #
      # it 'has a validation error on the field' do
      #   expect(subject).to_not be_valid
      #   expect(subject.errors[:grounds_for_appeal]).to_not be_empty
      # end
    end

    context 'when grounds_for_appeal is not valid' do
      pending 'decide what validations we have'
    end

    context 'when grounds_for_appeal is valid' do
      let(:grounds_for_appeal) { 'I disagree with HMRC.' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(grounds_for_appeal: 'I disagree with HMRC.')
        expect(subject.save).to be(true)
      end
    end
  end
end

