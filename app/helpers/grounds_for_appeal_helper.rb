module GroundsForAppealHelper

  def current_grounds_for_appeal_document
    return nil if current_tribunal_case.grounds_for_appeal_file_name.blank?
    Document.new(
      collection_ref: current_tribunal_case.files_collection_ref,
      name: current_tribunal_case.grounds_for_appeal_file_name
    )
  end

end
