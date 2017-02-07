module Steps::Appeal
  class DetermineCostController < Steps::AppealStepController
    def show
      raise 'No tribunal case in session' unless current_tribunal_case

      @cost_answers  = CostAnswersPresenter.new(current_tribunal_case)
    end
  end
end
