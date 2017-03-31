class Steps::ChallengeStepController < StepController
  private

  def decision_tree_class
    ChallengeDecisionTree
  end
end
