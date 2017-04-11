module Users
  class EmailConfirmationsController < ApplicationController
    before_action :ensure_user

    def edit
      @form_object = EmailConfirmationForm.new(
        user: current_user
      )
    end

    def update
      @form_object = EmailConfirmationForm.new(
        permitted_params.to_h.merge(user: current_user)
      )

      if @form_object.save
        redirect_to appeal_saved_path
      else
        render :edit
      end
    end

    private

    def ensure_user
      redirect_to case_not_found_errors_path unless current_user
    end

    def permitted_params
      params.fetch(:users_email_confirmation_form, {}).permit(:email_correct, :email)
    end
  end
end
