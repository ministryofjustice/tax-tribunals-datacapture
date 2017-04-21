module Users
  class PasswordsController < Devise::PasswordsController

    # Intercept the errors and if there is an 'invalid token' error, redirect back to the
    # reset password page. Otherwise, Devise will not show the error in the edit page,
    # because the error belongs to a hidden field.
    def update
      super do |user|
        if user.errors.include?(:reset_password_token)
          redirect_to new_user_password_path, alert: invalid_token_error and return
        end
      end
    end

    def reset_sent
    end

    private

    def invalid_token_error
      I18n.translate!(:invalid_token, scope: 'devise.passwords')
    end

    def after_resetting_password_path_for(_)
      user_session_path
    end

    def after_sending_reset_password_instructions_path_for(_)
      users_reset_sent_path
    end
  end
end
