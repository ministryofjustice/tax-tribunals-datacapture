class DetailsDecisionTree < DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :user_type
      after_user_type_step
    when :taxpayer_type
      edit(:taxpayer_details)
    when :taxpayer_details
      after_taxpayer_details_step
    when :has_representative
      after_has_representative_step
    when :representative_is_legal_professional
      after_representative_is_legal_professional_step
    when :representative_approval
      edit(:representative_type)
    when :representative_type
      edit(:representative_details)
    when :representative_details
      after_representative_details_step
    when :grounds_for_appeal
      edit(:outcome)
    when :outcome
      edit(:documents_checklist)
    when :documents_checklist
      after_documents_checklist
    when :check_answers
      home_path
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def after_user_type_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      edit(:taxpayer_type)
    when UserType::REPRESENTATIVE
      edit(:representative_is_legal_professional)
    end
  end

  def after_taxpayer_details_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      edit(:has_representative)
    when UserType::REPRESENTATIVE
      after_details_step
    end
  end

  def after_has_representative_step
    case tribunal_case.has_representative
    when HasRepresentative::YES
      edit(:representative_is_legal_professional)
    when HasRepresentative::NO
      after_details_step
    end
  end

  def after_representative_is_legal_professional_step
    case tribunal_case.representative_is_legal_professional
    when RepresentativeIsLegalProfessional::YES
      edit(:representative_type)
    when RepresentativeIsLegalProfessional::NO
      edit(:representative_approval)
    end
  end

  def after_representative_details_step
    case tribunal_case.user_type
    when UserType::TAXPAYER
      after_details_step
    when UserType::REPRESENTATIVE
      edit(:taxpayer_type)
    end
  end

  def after_details_step
    case tribunal_case.intent
    when Intent::TAX_APPEAL
      edit(:grounds_for_appeal)
    when Intent::CLOSE_ENQUIRY
      edit('/steps/closure/enquiry_details')
    end
  end

  def after_documents_checklist
    if tribunal_case.having_problems_uploading_documents?
      show(:documents_upload_problems)
    else
      show(:check_answers)
    end
  end
end
