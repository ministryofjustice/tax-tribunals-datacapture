class DetailsDecisionTree < TaxTribs::DecisionTree
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
    when :representative_professional_status
      after_representative_professional_status_step
    when :representative_approval
      edit(:representative_type)
    when :representative_type
      edit(:representative_details)
    when :representative_details
      after_representative_details_step
    when :grounds_for_appeal
      edit(:outcome)
    when :outcome
      edit(:letter_upload)
    when :letter_upload
      after_letter_upload
    when :check_answers
      root_path
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
      edit(:representative_professional_status)
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
      edit(:representative_professional_status)
    when HasRepresentative::NO
      after_details_step
    end
  end

  def after_representative_professional_status_step
    case tribunal_case.representative_professional_status
    when RepresentativeProfessionalStatus::ENGLAND_OR_WALES_OR_NI_LEGAL_REP,
         RepresentativeProfessionalStatus::SCOTLAND_LEGAL_REP
      edit(:representative_type)
    else
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

  def after_letter_upload
    if tribunal_case.having_problems_uploading?
      show(:documents_upload_problems)
    else
      show(:check_answers)
    end
  end
end
