class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_tribunal_case

  def current_tribunal_case
    @current_tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id])
  end
end
