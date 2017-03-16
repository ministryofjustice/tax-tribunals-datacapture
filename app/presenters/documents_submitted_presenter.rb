class DocumentsSubmittedPresenter < BaseAnswersPresenter
  #
  # If users said they were having problems uploading documents, even if some of
  # the documents might have been uploaded in any of the steps, we don't show them
  # in the generated case PDF (the `check your answers` page will not be shown in
  # this scenario, as the user will be diverted to a kickout page before).
  #
  def list(document_key)
    return [] if tribunal_case.having_problems_uploading_documents?
    tribunal_case.documents(document_key)
  end
end
