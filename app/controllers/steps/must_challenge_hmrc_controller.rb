class Steps::MustChallengeHmrcController < StepController
  def show
    raise 'No tribunal case in session' unless current_tribunal_case
  end
end
