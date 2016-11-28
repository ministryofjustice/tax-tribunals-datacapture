class Steps::DetailsStepController < StepController
  private

  def decision_tree_class
    DetailsDecisionTree
  end
end
