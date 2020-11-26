module Steps
  class SaveAndReturnController < StepController

    def index
      # @tribunal_cases = pending_user_cases.order(created_at: :asc)
    end

    def edit
      # binding.pry
      @form_object = SaveAndReturn::SaveForm.new
      # @tribunal_case = pending_case_from_params
    end

    def update
      # @tribunal_case = pending_case_from_params
      # @tribunal_case.update(user_case_reference: permitted_params[:user_case_reference])

      # redirect_to users_cases_path
    end

    private

    def permitted_params
      params.require(:tribunal_case).permit(:user_case_reference)
    end
  end
end
