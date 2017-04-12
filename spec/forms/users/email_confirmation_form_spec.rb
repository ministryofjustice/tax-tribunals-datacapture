require 'spec_helper'

RSpec.describe Users::EmailConfirmationForm do
  let(:arguments) { {
    user: user,
    email_correct: email_correct,
    email: email
  } }
  let(:user) { instance_double(User) }
  let(:email_correct) { true }
  let(:email) { 'shirley.schmidt@cranepooleandschmidt.com' }

  subject { described_class.new(arguments) }

  describe '#save' do
    let(:email_unique) { true }

    before do
      allow(User).to receive(:where).with(email: email).and_return(
        double('Collection', empty?: email_unique)
      )
    end

    context 'when no user is associated with the form' do
      let(:user) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when email_correct is true' do
      let(:email_correct) { true }
      let(:email) { nil }

      it 'returns true' do
        expect(subject.save).to eq(true)
      end
    end

    context 'when email_correct is false' do
      let(:email_correct) { false }

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

      context 'when email is given and is valid' do
        let(:email) { 'alan.shore@cranepooleandschmidt.com' }

        it 'updates the user and returns false (to get confirmation again)' do
          expect(user).to receive(:update).with(email: email).and_return(true)
          expect(subject.save).to eq(false)
        end
      end
    end
  end
end
