class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # This is required to get request attributes in to the production logs.
  # See the various lograge configurations in `production.rb`.
  def append_info_to_payload(payload)
    super
    payload[:referrer] = request&.referrer
    payload[:session_id] = request&.session&.id
    payload[:user_agent] = request&.user_agent
  end

  rescue_from Exception do |exception|
    case exception
    when Errors::InvalidSession, ActionController::InvalidAuthenticityToken
      redirect_to invalid_session_errors_path
    when Errors::CaseNotFound
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

  private

  def reset_tribunal_case_session
    session.delete(:tribunal_case_id)
  end

  def initialize_tribunal_case(attributes = {})
    TribunalCase.create(attributes).tap do |tribunal_case|
      session[:tribunal_case_id] = tribunal_case.id
    end
  end

  def check_tribunal_case_presence
    raise Errors::InvalidSession unless current_tribunal_case
  end

  def check_tribunal_case_status
    raise Errors::CaseSubmitted if current_tribunal_case.case_status&.submitted?
  end
end
