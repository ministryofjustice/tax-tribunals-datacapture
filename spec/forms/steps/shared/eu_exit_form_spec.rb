require 'spec_helper'

RSpec.describe Steps::Shared::EuExitForm do
  let(:arguments) { {
      tribunal_case: tribunal_case,
      eu_exit: eu_exit
  } }
  let(:tribunal_case) { instance_double(TribunalCase, eu_exit: nil) }
  let(:eu_exit) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do

    it { should_not validate_presence_of(:eu_exit) }

    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:eu_exit) { 'yes' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when eu_exit is not given' do
      it 'does not have any validation errors' do
        expect(subject.errors[:eu_exit]).to be_empty
      end

      it 'does not save the record' do
        expect(tribunal_case).to_not receive(:update)
      end
    end

    context 'when eu_exit is not valid' do
      let(:eu_exit) { 'INVALID VALUE' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:eu_exit]).to_not be_empty
      end
    end

    context 'when need_support is valid' do
      let(:eu_exit) { 'yes' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
            eu_exit: true
            ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
