class Steps::ClosureStepController < StepController
  private

  def decision_tree_class
    TaxTribs::ClosureDecisionTree
  end

  def intent
    Intent::CLOSE_ENQUIRY
  end
end
