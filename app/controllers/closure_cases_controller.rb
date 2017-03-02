class ClosureCasesController < CasesController
  private

  def presenter_class
    ClosurePresenter
  end

  def confirmation_path
    steps_closure_confirmation_path
  end
end
