require 'spec_helper'

RSpec.describe Steps::Details::WhatSupportForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    language_interpreter: nil,
    sign_language_interpreter: nil,
    hearing_loop: nil,
    disabled_access: disabled_access,
    other_support: other_support,
    other_support_details: other_support_details,
  } }

  let(:tribunal_case) { instance_double(TribunalCase) }
  let(:other_support) { nil }
  let(:other_support_details) { nil }
  let(:disabled_access) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      context 'when `other_support_details` is checked' do
        let(:other_support) { true }

        it { should validate_presence_of(:other_support_details) }
      end

      context 'when `other_support_details` is not checked' do
        it { should_not validate_presence_of(:other_support_details) }
      end

      context 'when no options are checked' do
        it 'should not be valid' do
          expect { subject.save }.should_not be_valid
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
