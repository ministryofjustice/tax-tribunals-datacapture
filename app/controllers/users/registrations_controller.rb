module Users
  class RegistrationsController < Devise::RegistrationsController
    # We are allowing to create new accounts only as part of saving a case in progress
    before_action :check_tribunal_case_presence, only: [:new, :create, :save_confirmation]

    # Using an after filter so we maintain the session for analytics purposes when rendering the view
    after_action :reset_tribunal_case_session, only: [:save_confirmation], if: -> { session[:save_for_later].nil? }

    def save_confirmation
      @email_address = current_tribunal_case.user.email
    end

    def update_confirmation
    end

    protected

    # We want, on purpose, to not sign in the user after registration, so not calling `super` here.
    def sign_up(_resource_name, user)
      TaxTribs::SaveCaseForLater.new(current_tribunal_case, user).save
      super if session[:save_for_later] == true
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
  end
end
