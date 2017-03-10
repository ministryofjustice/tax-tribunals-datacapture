class DocumentsSubmittedPresenter < BaseAnswersPresenter
  def list(document_key)
    tribunal_case.documents(document_key)
  end

  def grounds_for_appeal_text(default: nil)
    tribunal_case.grounds_for_appeal.present? ? tribunal_case.grounds_for_appeal : default
  end
end
