require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#last_sign_in_at' do
    specify { expect(described_class.column_names).to include('last_sign_in_at') }
  end

  describe 'blockable fields' do
    specify { expect(described_class.column_names).to include('failed_attempts') }
    specify { expect(described_class.column_names).to include('locked_at') }
  end

  describe '.purge!' do
    let(:user_class) { class_double(User) }

    around do |example|
      travel_to(Time.parse('2017-04-30')) do
        example.run
      end
    end

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        ["last_sign_in_at <= :date OR (created_at <= :date AND last_sign_in_at IS NULL)", date: 30.days.ago]
      ).and_return(user_class.as_null_object)

      described_class.purge!(30.days.ago)
    end

    it 'calls #destroy_all on the records it finds' do
      allow(described_class).to receive(:where).and_return(user_class)
      expect(user_class).to receive(:destroy_all)
      described_class.purge!(30.days.ago)
    end
  end

  describe 'email validation' do
    let(:user) { User.new(password: 'Fe94#lG1!') }
    context 'custom value casting' do
      #
      # This is just a quick test to ensure the `NormalisedEmailType` casting is being used.
      # A more in-deep test of all possible unicode substitutions can be found in:
      # spec/attributes/normalised_email_type_spec.rb
      #
      it 'should replace common unicode equivalent characters' do
        subject.email = "test\u2032ing@hyphened\u2010domain.com"
        expect(subject.email).to eq("test\u0027ing@hyphened\u002ddomain.com")
      end
    end


    context 'invalid' do
      list = ["testcom", "test@", "test@test", '*test@test.com','(test@test.com',')test@test.com','!test@test.com','&test@test.com','/test@test.com',';test@test.com']

      list.each do |email|
        it "#{email}" do
          user.email = email
          expect(user.valid?).to be false
        end
      end

      it 'custom error message' do
        user.email = '(test@test.com'
        user.valid?
        expect(user.errors.messages[:email]).to eq ["Enter an email address in the correct format, like name@example.com. An email address cannot contain *()!&/;"]
      end

    end

    context 'valid' do
      it 'test@test.com' do
        user.email = "test@test.com"
        expect(user.valid?).to be true
      end
    end

  end

  describe 'password validation' do
    let(:user) { User.new(password: password) }
    before do
      user.valid?
    end

    context 'strong password' do
      let(:password) { 'Fe94#lG1!' }

      it 'should not include password errors' do
        expect(user.errors[:password]).to be_empty
      end
    end

    context 'weak password' do
      let(:password) { 'foobar123' }

      it 'should have error message' do
        expect(user.errors[:password]).to include("Enter a stronger password")
      end
    end
  end
end
