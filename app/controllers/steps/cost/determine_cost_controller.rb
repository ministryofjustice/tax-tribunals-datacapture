class Steps::Cost::DetermineCostController < StepController
  def show
    raise 'No tribunal case in session' unless current_tribunal_case

    @change_answers = ChangeCostAnswersPresenter.new(current_tribunal_case)
    @lodgement_fee = CostDeterminer.new(current_tribunal_case).lodgement_fee

    current_tribunal_case.update(lodgement_fee: @lodgement_fee)
  end
end
