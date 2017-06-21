class Steps::HardshipStepController < StepController
  private

  def decision_tree_class
    TaxTribs::HardshipDecisionTree
  end
end
