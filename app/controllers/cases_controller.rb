class CasesController < ApplicationController
  def create
    new_case = CaseCreator.new(current_tribunal_case).call

    result_url = if new_case.success?
                   new_case.payment_url
                 else
                   flash[:alert] = new_case.errors
                   steps_details_check_answers_path
                 end

    redirect_to result_url
  end
end
