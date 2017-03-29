class AppealCasesController < CasesController
  def pdf_template
    'steps/details/check_answers/show'
  end

  private

  def presenter_class
    CheckAnswers::AppealAnswersPresenter
  end

  def confirmation_path
    steps_details_confirmation_path
  end
end
