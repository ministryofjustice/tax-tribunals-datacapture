class GlimrCasesController < ApplicationController

  def create
    new_case = CaseCreator.new(current_tribunal_case).call

    result_url = if new_case.success?
                   new_case.payment_url
                 else
                   # TODO: change once we have the summary step
                   flash[:alert] = new_case.errors
                   steps_details_start_path
                 end

    redirect_to result_url
  end

end
