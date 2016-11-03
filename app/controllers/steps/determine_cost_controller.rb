class Steps::DetermineCostController < StepController
  def show
    raise 'No tribunal case in session' unless current_tribunal_case

    @change_answers = ChangeCostAnswersPresenter.new(current_tribunal_case)
  end
end
