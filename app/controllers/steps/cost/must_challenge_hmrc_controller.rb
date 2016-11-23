class Steps::Cost::MustChallengeHmrcController < Steps::CostStepController
  def show
    raise 'No tribunal case in session' unless current_tribunal_case
  end
end
