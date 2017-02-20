class Steps::AppealStepController < StepController
  private

  def decision_tree_class
    AppealDecisionTree
  end

  def intent
    Intent::TAX_APPEAL
  end
end
