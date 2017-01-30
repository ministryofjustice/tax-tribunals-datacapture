class Steps::ClosureStepController < StepController
  private

  def decision_tree_class
    ClosureDecisionTree
  end
end
