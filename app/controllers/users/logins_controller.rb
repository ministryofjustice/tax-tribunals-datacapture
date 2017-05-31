module Users
  class LoginsController < Devise::SessionsController
    def save_confirmation
      @email_address = session[:confirmation_email_address]
    end

    def logged_out
    end

    protected

    def sign_in(_resource_name, user)
      super
      save_for_later = TaxTribs::SaveCaseForLater.new(current_tribunal_case, user)
      save_for_later.save
      session[:confirmation_email_address] = user.email if save_for_later.email_sent?
    end

    # Devise will try to return to a previously login-protected page if available,
    # otherwise this is the fallback route to redirect the user after login
    def signed_in_root_path(_)
      current_tribunal_case ? users_login_save_confirmation_path : users_cases_path
    end

    def after_sign_out_path_for(_)
      users_login_logged_out_path
    end
  end
end
