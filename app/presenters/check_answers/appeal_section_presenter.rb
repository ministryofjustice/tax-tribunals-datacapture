module CheckAnswers
  class AppealSectionPresenter < SectionPresenter
    def name
      :appeal
    end

    def answers
      [
        case_type_answer,
        challenged_decision_answer,
        Answer.new(:challenged_decision_status, tribunal_case.challenged_decision_status, change_path: edit_steps_challenge_decision_status_path),
        dispute_type_answer,
        Answer.new(:penalty_level, tribunal_case.penalty_level, change_path: edit_steps_appeal_penalty_amount_path),
        Answer.new(:penalty_amount, tribunal_case.penalty_amount, raw: true),
        Answer.new(:tax_amount, tribunal_case.tax_amount, raw: true)
      ].select(&:show?)
    end

    private

    def case_type_answer
      if tribunal_case.case_type == CaseType::OTHER
        Answer.new(:case_type, tribunal_case.case_type_other_value, raw: true, change_path: edit_steps_appeal_case_type_show_more_path)
      else
        Answer.new(:case_type, tribunal_case.case_type, change_path: edit_steps_appeal_case_type_path)
      end
    end

    def dispute_type_answer
      if tribunal_case.dispute_type == DisputeType::OTHER
        Answer.new(:dispute_type, tribunal_case.dispute_type_other_value, raw: true, change_path: edit_steps_appeal_dispute_type_path)
      else
        Answer.new(:dispute_type, tribunal_case.dispute_type, change_path: edit_steps_appeal_dispute_type_path)
      end
    end

    def challenged_decision_answer
      if tribunal_case.case_type&.direct_tax?
        Answer.new(:challenged_decision_direct, tribunal_case.challenged_decision, change_path: edit_steps_challenge_decision_path)
      else
        Answer.new(:challenged_decision_indirect, tribunal_case.challenged_decision, change_path: edit_steps_challenge_decision_path)
      end
    end
  end
end
