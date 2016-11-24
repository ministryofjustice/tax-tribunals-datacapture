class Steps::LatenessStepController < StepController
  private

  def decision_tree_class
    LatenessDecisionTree
  end
end
