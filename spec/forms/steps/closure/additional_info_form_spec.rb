require 'spec_helper'

RSpec.describe Steps::Closure::AdditionalInfoForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    closure_additional_info: closure_additional_info
  } }
  let(:tribunal_case) { instance_double(TribunalCase, closure_additional_info: nil) }
  let(:closure_additional_info) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when closure_additional_info is provided' do
      let(:closure_additional_info) { 'my info' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          closure_additional_info: 'my info'
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when closure_additional_info is not provided' do
      let(:tribunal_case) { instance_double(TribunalCase, closure_additional_info: 'my info') }
      let(:closure_additional_info) { nil }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          closure_additional_info: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when closure_additional_info is already the same on the model' do
      let(:tribunal_case) { instance_double(TribunalCase, closure_additional_info: 'my info') }
      let(:closure_additional_info) { 'my info' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
