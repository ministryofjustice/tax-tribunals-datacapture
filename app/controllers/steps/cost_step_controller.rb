class Steps::CostStepController < StepController
  private

  def decision_tree_class
    CostDecisionTree
  end
end
