require 'spec_helper'

RSpec.describe Users::RegistrationForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    email: email,
    password: password,
    user_case_reference: user_case_reference
  } }
  let(:tribunal_case) { instance_double(TribunalCase) }
  let(:email) { 'shirley.schmidt@cranepooleandschmidt.com' }
  let(:password) { 'passw0rd' }
  let(:user_case_reference) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    let(:email_unique) { true }

    before do
      allow(User).to receive(:where).with(email: email).and_return(
        double('Collection', empty?: email_unique)
      )
    end

    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when email is not given' do
      let(:email) { nil }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:email]).to_not be_empty
      end
    end

    context 'when email is not valid' do
      let(:email) { '123 Anytown Road, Poughkeepsie' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:email]).to_not be_empty
      end
    end

    context 'when email is not unique' do
      let(:email_unique) { false }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:email]).to_not be_empty
      end
    end

    context 'when password is not given' do
      let(:password) { nil }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:password]).to_not be_empty
      end
    end

    context 'when password is too short' do
      let(:password) { 'passwor' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:password]).to_not be_empty
      end
    end

    context 'when the registration is valid' do
      it 'creates a user' do
        expect(User).to receive(:create).with(email: email, password: password).and_return(true)
        expect(subject.save).to eq(true)
      end
    end
  end
end
