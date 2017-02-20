class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Errors::CaseNotFound do
    redirect_to case_not_found_errors_path
  end

  rescue_from Errors::CaseSubmitted do
    redirect_to case_submitted_errors_path
  end

  helper_method :current_tribunal_case

  def current_tribunal_case
    @current_tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id])
  end

  def current_step_path
    session[:current_step_path]
  end

  private

  def initialize_tribunal_case(intent:)
    TribunalCase.create(intent: intent).tap do |tribunal_case|
      session[:tribunal_case_id] = tribunal_case.id
    end
  end

  def check_tribunal_case_presence
    raise Errors::CaseNotFound unless current_tribunal_case
  end

  def check_tribunal_case_status
    raise Errors::CaseSubmitted if current_tribunal_case.case_status == CaseStatus::SUBMITTED
  end
end
