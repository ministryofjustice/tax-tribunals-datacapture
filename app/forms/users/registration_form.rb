module Users
  class RegistrationForm < BaseForm
    attr_reader :user

    attribute :email, String
    attribute :password, String
    attribute :user_case_reference, String

    validates :email, email: true, unique_user_email: true
    validates :password, length: { minimum: 8 }

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      @user = User.create(email: email, password: password)
    end
  end
end
