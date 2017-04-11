module Users
  class RegistrationsController < ApplicationController
    before_action :ensure_tribunal_case

    def new
      @form_object = RegistrationForm.new(
        tribunal_case: current_tribunal_case
      )
    end

    def create
      @form_object = RegistrationForm.new(
        permitted_params.to_h.merge(tribunal_case: current_tribunal_case)
      )

      if @form_object.save
        sign_in(@form_object.user)
        redirect_to edit_users_email_confirmation_path
      else
        render :new
      end
    end

    private

    def ensure_tribunal_case
      redirect_to case_not_found_errors_path unless current_tribunal_case
    end

    def permitted_params
      params.fetch(:users_registration_form, {}).permit(:email, :password, :user_case_reference)
    end
  end
end
