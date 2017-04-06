class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Exception do |exception|
    case exception
    when Errors::CaseNotFound, ActionController::InvalidAuthenticityToken
      redirect_to case_not_found_errors_path
    when Errors::CaseSubmitted
      redirect_to case_submitted_errors_path
    else
      raise if Rails.application.config.consider_all_requests_local

      Raven.capture_exception(exception)
      redirect_to unhandled_errors_path
    end
  end

  helper_method :current_tribunal_case

  def current_tribunal_case
    @current_tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id])
  end

  def current_step_path
    session[:current_step_path]
  end

  def after_sign_in_path_for(_)
    root_path
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
    raise Errors::CaseSubmitted if current_tribunal_case.case_status&.submitted?
  end
end
