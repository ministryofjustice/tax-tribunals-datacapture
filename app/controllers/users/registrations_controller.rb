module Users
  class RegistrationsController < Devise::RegistrationsController
    # We are allowing to create new accounts only as part of saving a case in progress
    before_action :ensure_tribunal_case, only: [:new, :create]

    def save_confirmation
      @email_address = session[:confirmation_email_address]
    end

    def update_confirmation
    end

    protected

    # We want, on purpose, to not sign in the user after registration, so not calling `super` here.
    # Also due to this, we need to store somewhere the email of the created account, to show in the confirmation.
    def sign_up(_resource_name, user)
      SaveCaseForLater.new(current_tribunal_case, user).save
      session[:confirmation_email_address] = user.email
      reset_tribunal_case_session  # so we redirect the user to the portfolio after login back
    end

    # Devise will not give an error when leaving blank the new password, it will just ignore the update,
    # which is a very confusing behaviour IMO. Overriding this method to force validation on this field.
    # https://github.com/plataformatec/devise/issues/1955
    def update_resource(resource, params)
      params[:password] = '*' if params[:password].blank?
      super
    end

    def after_sign_up_path_for(_)
      users_registration_save_confirmation_path
    end

    def after_update_path_for(_)
      users_registration_update_confirmation_path
    end

    private

    def ensure_tribunal_case
      redirect_to case_not_found_errors_path unless current_tribunal_case
    end
  end
end
