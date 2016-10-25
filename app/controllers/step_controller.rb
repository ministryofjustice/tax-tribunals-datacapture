class StepController < ApplicationController
  def edit
    raise 'No tribunal case in session' unless current_tribunal_case
  end

  private

  def current_tribunal_case
    @current_tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id])
  end
end
