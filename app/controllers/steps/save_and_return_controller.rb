module Steps
  class SaveAndReturnController < StepController

    def edit
      @form_object = SaveAndReturn::SaveForm.new
    end

    def update
      if permitted_params[:save_for_later] == "true"
        session[:save_for_later] = true
        redirect_to new_user_registration_path
      else
        redirect_to destination
      end
    end

    private

    def permitted_params
      return {} if params[:save_and_return_save_form].nil?
      params[:save_and_return_save_form].permit(:save_for_later)
    end

    def destination
      session['next_step'] || root_url
    end

  end
end
