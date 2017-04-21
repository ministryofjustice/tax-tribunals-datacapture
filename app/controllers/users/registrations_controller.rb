module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :ensure_tribunal_case

    def signup_save_confirmation
      @user_email = session[:signed_up_user_email]
    end

    protected

    # We want, on purpose, to not sign in the user after registration, so not calling `super` here.
    # Also due to this, we need to store somewhere the email of the created account, to show in the confirmation.
    def sign_up(_resource_name, resource)
      current_tribunal_case.update(user: resource)      # TODO: extract to service object
      send_confirmation_email                           # TODO: extract to service object
      session[:signed_up_user_email] = resource.email
    end

    def after_sign_up_path_for(_)
      users_signup_save_confirmation_path
    end

    private

    def ensure_tribunal_case
      redirect_to case_not_found_errors_path unless current_tribunal_case
    end

    def send_confirmation_email
      NotifyMailer.new_account_confirmation(current_tribunal_case).deliver_later
    end
  end
end
