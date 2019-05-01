require 'spec_helper'

RSpec.describe Steps::Details::NeedSupportForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    need_support: need_support
  } }
  let(:tribunal_case) { instance_double(TribunalCase, need_support: nil) }
  let(:need_support) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:need_support) { 'yes' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when need_support is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:need_support]).to_not be_empty
      end
    end

    context 'when need_support is not valid' do
      let(:need_support) { 'INVALID VALUE' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:need_support]).to_not be_empty
      end
    end

    context 'when need_support is valid' do
      let(:need_support) { 'yes' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          need_support: NeedSupport::YES,
          language_interpreter: nil,
          language_interpreter_details: nil,
          sign_language_interpreter: nil,
          sign_language_interpreter_details: nil,
          hearing_loop: nil,
          disabled_access: nil,
          other_support: nil,
          other_support_details: nil,
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when need_support is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          need_support: NeedSupport::YES
        )
      }
      let(:need_support) { 'yes' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
