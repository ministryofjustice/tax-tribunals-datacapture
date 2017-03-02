class AppealCasesController < CasesController
  private

  def presenter_class
    AppealPresenter
  end

  def confirmation_path
    steps_details_confirmation_path
  end
end
