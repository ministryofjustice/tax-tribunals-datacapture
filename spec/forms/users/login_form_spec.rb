require 'spec_helper'

RSpec.describe Users::LoginForm do
  let(:arguments) { {
    tribunal_case: tribunal_case,
    email: email,
    password: password
  } }
  let(:tribunal_case) { instance_double(TribunalCase) }
  let(:email) { 'shirley.schmidt@cranepooleandschmidt.com' }
  let(:password) { 'passw0rd' }

  subject { described_class.new(arguments) }

  describe '#save' do
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

    context 'when the user does not exist' do
      before do
        expect(User).to receive(:find_by).with(email: email).and_return(nil)
      end

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the object itself' do
        expect(subject).to_not be_valid
        expect(subject.errors[:base]).to_not be_empty
      end

      it 'does not set the user' do
        subject.save
        expect(subject.user).to be_nil
      end
    end

    context 'when the password is wrong' do
      let(:user) { instance_double(User) }

      before do
        expect(User).to receive(:find_by).with(email: email).and_return(user)
        expect(user).to receive(:valid_password?).with(password).and_return(false)
      end

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the object itself' do
        expect(subject).to_not be_valid
        expect(subject.errors[:base]).to_not be_empty
      end

      it 'does not set the user' do
        subject.save
        expect(subject.user).to be_nil
      end
    end

    context 'when the credentials are correct' do
      let(:user) { instance_double(User) }

      before do
        expect(User).to receive(:find_by).with(email: email).and_return(user)
        expect(user).to receive(:valid_password?).with(password).and_return(true)
      end

      it 'returns true' do
        expect(subject.save).to eq(true)
      end

      it 'sets the user' do
        subject.save
        expect(subject.user).to eq(user)
      end
    end
  end
end
