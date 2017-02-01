class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
