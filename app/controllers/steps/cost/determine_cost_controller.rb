module Steps::Cost
  class DetermineCostController < Steps::CostStepController
    def show
      raise 'No tribunal case in session' unless current_tribunal_case

      @cost_answers  = CostAnswersPresenter.new(current_tribunal_case)
      @lodgement_fee = current_tribunal_case.lodgement_fee
    end
  end
end
