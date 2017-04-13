module Users
  class LoginForm < BaseForm
    attr_reader :user

    attribute :email, String
    attribute :password, String

    validates :email, email: true
    validates :password, presence: true

    validate :username_and_password_correct

    private

    def persist!
      true
    end

    def username_and_password_correct
      user = User.find_by(email: email)

      unless user && user.valid_password?(password)
        errors.add(:base, :invalid_credentials)

        # Return so we only assign the user if the username and password are correct
        return
      end

      @user = user
    end
  end
end
