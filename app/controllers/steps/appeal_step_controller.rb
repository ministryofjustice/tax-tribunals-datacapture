class Steps::AppealStepController < StepController
  private

  def decision_tree_class
    AppealDecisionTree
  end
end
