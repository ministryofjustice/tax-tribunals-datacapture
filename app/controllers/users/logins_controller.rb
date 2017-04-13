module Users
  class LoginsController < ApplicationController
    def new
      @form_object = LoginForm.new(
        tribunal_case: current_tribunal_case
      )
    end

    def create
      @form_object = LoginForm.new(
        permitted_params.to_h.merge(tribunal_case: current_tribunal_case)
      )

      if @form_object.save
        sign_in(@form_object.user)
        redirect_to users_cases_path
      else
        render :new
      end
    end

    private

    def permitted_params
      params.fetch(:users_login_form, {}).permit(:email, :password)
    end
  end
end
