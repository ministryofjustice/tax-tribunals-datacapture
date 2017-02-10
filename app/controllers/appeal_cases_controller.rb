class AppealCasesController < CasesController
  private

  def presenter_class
    AppealPresenter
  end

  def check_answers_path
    steps_details_check_answers_path
  end

  def confirmation_path
    steps_details_confirmation_path
  end
end
