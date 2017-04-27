module Users
  class CasesController < ApplicationController
    before_action :authenticate_user!

    def index
      @tribunal_cases = pending_user_cases
    end

    def edit
      @tribunal_case = pending_user_cases.find(params[:id])
    end

    def update
      @tribunal_case = pending_user_cases.find(params[:id])
      @tribunal_case.update(user_case_reference: permitted_params[:user_case_reference])

      redirect_to users_cases_path
    end

    def resume
      tribunal_case = pending_user_cases.find(params[:id])
      session[:tribunal_case_id] = tribunal_case.id

      redirect_to resume_path_for(tribunal_case.freeze)
    end

    def destroy
      pending_user_cases.find(params[:id]).destroy
      redirect_to users_cases_path
    end

    private

    def pending_user_cases
      current_user.pending_tribunal_cases
    end

    # If there is no case_type, there is little point taking the users to the `check your answers` page as
    # technically they didn't answer a single question yet, so in this (bit of an edge case) scenario, we
    # get them directly to the the corresponding step `root path`, which at the moment is the case_type step.
    def resume_path_for(tribunal_case)
      if tribunal_case.intent.eql?(Intent::TAX_APPEAL)
        tribunal_case.case_type ? resume_steps_details_check_answers_path : steps_appeal_root_path
      else
        tribunal_case.closure_case_type ? resume_steps_closure_check_answers_path : steps_closure_root_path
      end
    end

    def permitted_params
      params.require(:tribunal_case).permit(:user_case_reference)
    end
  end
end
