class ChallengeDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    # TODO: challenge decisions to be moved here from AppealDecisionTree
    case step_name.to_sym
    when :challenged_decision
    when :challenged_decision_status
    else
      raise "Invalid step '#{step_params}'"
    end
  end
end
