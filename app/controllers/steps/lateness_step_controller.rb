class Steps::LatenessStepController < StepController
  private

  def decision_tree_class
    TaxTribs::LatenessDecisionTree
  end
end
