module Users
  class CasesController < ApplicationController
    before_action :authenticate_user!

    def index
      @tribunal_cases = current_user.pending_tribunal_cases
    end

    def edit
      @tribunal_case = current_user.pending_tribunal_cases.find(params[:id])
    end

    def update
      @tribunal_case = current_user.pending_tribunal_cases.find(params[:id])
      @tribunal_case.update(user_case_reference: permitted_params[:user_case_reference])

      redirect_to users_cases_path
    end

    def resume
      tribunal_case = current_user.pending_tribunal_cases.find(params[:case_id])
      session[:tribunal_case_id] = tribunal_case.id

      redirect_to resume_check_answers_path_for(tribunal_case)
    end

    def destroy
      tribunal_case = current_user.tribunal_cases.find(params[:id])
      tribunal_case.destroy

      redirect_to users_cases_path
    end

    private

    def resume_check_answers_path_for(tribunal_case)
      if tribunal_case.intent.eql?(Intent::TAX_APPEAL)
        resume_steps_details_check_answers_path
      else
        resume_steps_closure_check_answers_path
      end
    end

    def permitted_params
      params.require(:tribunal_case).permit(:user_case_reference)
    end
  end
end
