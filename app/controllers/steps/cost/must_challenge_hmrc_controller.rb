module Steps::Cost
  class MustChallengeHmrcController < Steps::CostStepController
    def show
      raise 'No tribunal case in session' unless current_tribunal_case
    end
  end
end
