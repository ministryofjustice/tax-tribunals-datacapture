module Users
  class PasswordsController < Devise::PasswordsController
    # Intercept the creation of the reset token given an email address, and check this
    # value as otherwise Devise will not error if the email address is left blank.
    # This will not error on malformed email addresses as we are in Paranoid mode and Devise
    # will consider any input as valid, but at least we cover the blank scenario.
    def create
      email = params[:user][:email]

      unless email.empty?
        user = User.find_by(email: email)
        if (Time.zone.now.to_i - user&.reset_password_sent_at.to_i) < 1.second
          redirect_to users_password_reset_sent_path and return
        end
      end

      super do |user|
        if user.errors.added?(:email, :blank)
          respond_with(user) and return
        end
      end
    end

    # Intercept the errors and if there is any on the reset_password_token field, redirect back
    # to the reset password page. Otherwise, Devise will not show the error in the edit page,
    # because it belongs to a hidden field.
    def update
      super do |user|
        if user.errors.include?(:reset_password_token)
          redirect_to new_user_password_path, alert: invalid_token_error and return
        end
      end
    end

    def reset_confirmation
    end

    def reset_sent
    end

    private

    def invalid_token_error
      I18n.translate!(:invalid_token, scope: 'devise.passwords')
    end

    def after_resetting_password_path_for(_)
      users_password_reset_confirmation_path
    end

    def after_sending_reset_password_instructions_path_for(_)
      users_password_reset_sent_path
    end
  end
end
