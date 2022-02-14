require 'spec_helper'

RSpec.describe Steps::Shared::WhatSupportForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    language_interpreter: language_interpreter,
    language_interpreter_details: language_interpreter_details,
    sign_language_interpreter: sign_language_interpreter,
    sign_language_interpreter_details: sign_language_interpreter_details,
    hearing_loop: nil,
    disabled_access: disabled_access,
    other_support: other_support,
    other_support_details: other_support_details,
  } }

  let(:tribunal_case) { instance_double(TribunalCase) }
  let(:other_support) { nil }
  let(:other_support_details) { nil }
  let(:language_interpreter) { nil }
  let(:language_interpreter_details) { nil }
  let(:sign_language_interpreter) { nil }
  let(:sign_language_interpreter_details) { nil }
  let(:disabled_access) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      context 'when `other_support` is checked' do
        let(:other_support) { true }

        it { should validate_presence_of(:other_support_details) }
      end

      context 'when `other_support` is not checked' do
        it { should_not validate_presence_of(:other_support_details) }
      end

      context 'when `language_interpreter` is checked' do
        let(:language_interpreter) { true }

        it { should validate_presence_of(:language_interpreter_details) }
      end

      context 'when `language_interpreter` is not checked' do
        it { should_not validate_presence_of(:language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is checked' do
        let(:sign_language_interpreter) { true }

        it { should validate_presence_of(:sign_language_interpreter_details) }
      end

      context 'when `sign_language_interpreter` is not checked' do
        it { should_not validate_presence_of(:sign_language_interpreter_details) }
      end

      context 'when no answers are checked' do
        it 'should display the what support validation message' do
          subject.valid?
          subject.errors[:what_support].should include("Select what support you need at the hearing")
        end
      end

      context 'when at least one answer is checked' do
        let(:disabled_access) { true }

        it 'should not display the what support validation message' do
          subject.valid?
          subject.errors[:what_support].should_not include("Select what support you need at the hearing")
        end
      end
    end

    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:disabled_access) { true }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end
  end
end
