class ClosureCasesController < CasesController
  private

  def presenter_class
    ClosurePresenter
  end

  def check_answers_path
    steps_closure_check_answers_path
  end

  def confirmation_path
    steps_closure_confirmation_path
  end
end
