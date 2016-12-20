class DocumentsSubmittedPresenter < BaseAnswersPresenter
  def list(filter: [])
    tribunal_case.documents(filter: filter)
  end

  def grounds_for_appeal_text(default: '')
    tribunal_case.grounds_for_appeal.present? ? tribunal_case.grounds_for_appeal : default
  end
end
