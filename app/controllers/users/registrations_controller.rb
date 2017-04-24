module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :ensure_tribunal_case

    def save_confirmation
      @email_address = session[:confirmation_email_address]
    end

    protected

    # We want, on purpose, to not sign in the user after registration, so not calling `super` here.
    # Also due to this, we need to store somewhere the email of the created account, to show in the confirmation.
    def sign_up(_resource_name, user)
      SaveCaseForLater.new(current_tribunal_case, user).save
      session[:confirmation_email_address] = user.email
    end

    def after_sign_up_path_for(_)
      users_registration_save_confirmation_path
    end

    private

    def ensure_tribunal_case
      redirect_to case_not_found_errors_path unless current_tribunal_case
    end
  end
end
