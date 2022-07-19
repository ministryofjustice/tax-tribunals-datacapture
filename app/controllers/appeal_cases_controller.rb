class AppealCasesController < GlimrCasesController
  def pdf_template
    'steps/details/check_answers/show'
  end

  def presenter_class
    CheckAnswers::AppealAnswersPresenter
  end

  private

  def confirmation_path
    steps_details_confirmation_path
  end
end
