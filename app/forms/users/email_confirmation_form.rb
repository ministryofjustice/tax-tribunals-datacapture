module Users
  class EmailConfirmationForm < BaseForm
    attr_accessor :user

    attribute :email, String
    attribute :email_correct, Boolean

    validates :email, email: true, unique_user_email: true, if: :validate_email?

    private

    def validate_email?
      !email_correct
    end

    def persist!
      raise 'No user given' unless user
      return true if email_correct

      user.update(email: email)

      # Returns false to render the page again to (re-)confirm the new email
      return false
    end
  end
end
