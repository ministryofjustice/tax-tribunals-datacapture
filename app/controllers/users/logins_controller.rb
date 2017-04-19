module Users
  class LoginsController < Devise::SessionsController
    def create
      super do |user|
        current_tribunal_case&.update(user: user)
      end
    end

    protected

    # Devise will try to return to a previously login-protected page if available,
    # otherwise this is the fallback route to redirect the user after login
    def signed_in_root_path(_)
      users_cases_path
    end
  end
end
