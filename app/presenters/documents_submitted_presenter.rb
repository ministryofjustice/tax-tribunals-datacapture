class DocumentsSubmittedPresenter < BaseAnswersPresenter
  #
  # If users said they were having problems uploading documents, even if some of
  # the documents might have been uploaded in any of the steps, we don't show them
  # in the generated case PDF (the `check your answers` page will not be shown in
  # this scenario, as the user will be diverted to a kickout page before).
  #
  def supporting_documents
    return [] if tribunal_case.having_problems_uploading_documents?
    tribunal_case.documents(:supporting_documents)
  end

  def grounds_for_appeal_file_name
    tribunal_case.documents(:grounds_for_appeal).first&.name
  end

  def hardship_reason_file_name
    tribunal_case.documents(:hardship_reason).first&.name
  end

  def representative_approval_file_name
    tribunal_case.documents(:representative_approval).first&.name
  end
end
