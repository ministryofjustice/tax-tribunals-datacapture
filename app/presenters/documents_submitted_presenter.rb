class DocumentsSubmittedPresenter < BaseAnswersPresenter
  def list
    tribunal_case.documents(:supporting_documents)
  end

  def grounds_for_appeal_text(default: '')
    tribunal_case.grounds_for_appeal.present? ? tribunal_case.grounds_for_appeal : default
  end
end
