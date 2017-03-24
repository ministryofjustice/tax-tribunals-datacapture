require 'spec_helper'

RSpec.describe Steps::Details::UserTypeForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    user_type: user_type
  } }
  let(:tribunal_case) { instance_double(TribunalCase, user_type: nil) }
  let(:user_type) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:user_type) { 'taxpayer' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when user_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:user_type]).to_not be_empty
      end
    end

    context 'when user_type is not valid' do
      let(:user_type) { 'concerned_citizen' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:user_type]).to_not be_empty
      end
    end

    context 'when user_type is valid' do
      let(:user_type) { 'representative' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          user_type: UserType::REPRESENTATIVE,
          has_representative: nil,
          representative_professional_status: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when user_type is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          user_type: UserType::TAXPAYER
        )
      }
      let(:user_type) { 'taxpayer' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end

