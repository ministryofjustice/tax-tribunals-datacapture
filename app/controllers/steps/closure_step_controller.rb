class Steps::ClosureStepController < StepController
  private

  # :nocov:
  def decision_tree_class
    ClosureDecisionTree
  end
  # :nocov:
end
