class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_tribunal_case, :current_grounds_for_appeal_document

  def current_tribunal_case
    @current_tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id])
  end

  def current_files_collection_ref
    current_tribunal_case.files_collection_ref
  end

  def current_grounds_for_appeal_document
    return nil if current_tribunal_case.grounds_for_appeal_file_name.blank?
    Document.new(
      collection_ref: current_tribunal_case.files_collection_ref,
      name: current_tribunal_case.grounds_for_appeal_file_name
    )
  end
end
