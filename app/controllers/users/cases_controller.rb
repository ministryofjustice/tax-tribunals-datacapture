module Users
  class CasesController < ApplicationController
    before_action :authenticate_user!

    def index
      @tribunal_cases = current_user.pending_tribunal_cases
    end

    def resume
      tribunal_case = current_user.pending_tribunal_cases.find(params[:case_id])
      session[:tribunal_case_id] = tribunal_case.id

      redirect_to check_your_answers_path_for(tribunal_case)
    end

    def destroy
      tribunal_case = current_user.tribunal_cases.find(params[:id])
      tribunal_case.destroy

      redirect_to users_cases_path
    end

    private

    def check_your_answers_path_for(tribunal_case)
      if tribunal_case.intent.eql?(Intent::TAX_APPEAL)
        steps_details_check_answers_path
      else
        steps_closure_check_answers_path
      end
    end
  end
end