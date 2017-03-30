class Steps::ChallengeStepController < StepController
  private

  # TODO: no coverage temporary until we move the logic from AppealDecisionTree
  # :nocov:
  def decision_tree_class
    ChallengeDecisionTree
  end
  # :nocov:
end
