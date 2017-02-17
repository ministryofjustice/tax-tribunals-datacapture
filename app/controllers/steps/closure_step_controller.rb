class Steps::ClosureStepController < StepController
  private

  def decision_tree_class
    ClosureDecisionTree
  end

  def intent
    Intent::CLOSE_ENQUIRY
  end
end
