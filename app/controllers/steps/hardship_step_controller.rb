class Steps::HardshipStepController < StepController
  private

  def decision_tree_class
    HardshipDecisionTree
  end
end
