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

      context 'too long' do
        it 'has error message' do
          user.email = long_email(257)
          user.valid?
          expect(user.errors.messages[:email]).to eq ["Email is too long (maximum is 256 characters)"]
        end
      end
    end

    context 'valid' do
      it 'test@test.com' do
        user.email = "test@test.com"
        expect(user.valid?).to be true
      end

      context 'long email' do
        it do
          user.email = long_email(256)
          expect(user.valid?).to be true
        end
      end

    end

  end

  describe 'password' do
    let(:user) { User.new(password: password) }
    before do
      user.valid?
    end

    context "accepts valid passwords" do
      let(:password) { 'ab3Df21!' }
      it '' do
        expect(user.errors[:password]).to be_empty
      end
    end

    I18n.available_locales.each do |locale|
      context "with #{locale.upcase} language" do
        context "must be 8 characters long" do
          let(:password) { 'a'*7 }

          it 'so does not accept short passwords' do
            expect(user.errors[:password]).to include(
              I18n.t(
'activerecord.errors.models.user.attributes.password.too_short'))
          end
        end

        context "is allowed to be 8 characters long" do
          let(:password) { 'ab3Df21!' }

          it 'so accepts long passwords' do
            expect(user.errors[:password]).to be_empty
          end
        end

        context "does not accept common passwords" do
          %w"airborne elephant snowball 55555555".each do |pass|
            let(:password) { pass }
            it "such as #{pass}" do
              expect(user.errors[:password]).to include(
                I18n.t('errors.messages.password.password_strength'))
            end
          end
        end

        context "is not the same as the user's email" do
          let(:password) { 'test@example.com' }
          it "" do
            user.email = 'test@example.com'
            user.valid?
            expect(user.errors[:password]).to include(
              I18n.t('errors.messages.password.password_strength'))
          end
        end
      end
    end
  end

  describe '::Signin class' do
    let(:email) { 'foo@bar.com' }
    let(:password) { 'XIY19@fdb' }
    let(:user_signin) { User::Signin.new(email: email, password: password) }
    before { user_signin.valid? }

    context 'validates email format' do
      let(:email) { 'foo@bar.c' }
      it 'adds error' do
        error = user_signin.errors.details[:email]
        expect(error).to eq([{error: :invalid, value: "foo@bar.c"}])
      end
    end

    context 'validates email presence' do
      let(:email) { '' }
      it 'adds error' do
        error = user_signin.errors.details[:email]
        expect(error).to eq([{error: :blank}])
      end
    end

    context 'validates password presence' do
      let(:password) { '' }

      it 'adds error' do
        error = user_signin.errors.details[:password]
        expect(error).to eq([{error: :blank}])
      end
    end

    context 'validates email password combination' do
      it 'adds error' do
        error = user_signin.errors.details[:base]
        expect(error).to eq([{error: :invalid}])
      end
    end
  end

  describe '.signin_errors' do
    it 'returns a user::signin filled with error messages' do
      obj = User.signin_errors(email: 'foo@bar.com', password: 'XIY19@fdb')
      expect(obj).to be_kind_of(User::Signin)
      expect(obj.errors).to be_present
    end
  end
end
