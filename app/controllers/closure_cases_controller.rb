class ClosureCasesController < GlimrCasesController
  def pdf_template
    'steps/closure/check_answers/show'
  end

  private

  def presenter_class
    CheckAnswers::ClosureAnswersPresenter
  end

  def confirmation_path
    steps_closure_confirmation_path
  end
end
