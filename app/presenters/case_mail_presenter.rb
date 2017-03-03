class CaseMailPresenter < SimpleDelegator
  # Initialise with a TribunalCase instance and any method not
  # defined in this class will be forwarded automatically to that instance.

  # GOV.UK Notify expects this to be literals
  def show_case_reference?
    case_reference.present? ? 'yes' : 'no'
  end

  # GOV.UK Notify does not accept `nil` values, instead use empty strings
  def case_reference
    tribunal_case.case_reference.to_s
  end

  # Email address of whoever filled the form out first. If it's the representative,
  # they would get it, otherwise the taxpayer would
  def recipient_email
    started_by_representative? ? representative_contact_email : taxpayer_contact_email
  end

  # Same logic as recipient email
  def recipient_first_name
    started_by_representative? ? representative_individual_first_name : taxpayer_individual_first_name
  end

  # Same logic as recipient email
  def recipient_last_name
    started_by_representative? ? representative_individual_last_name : taxpayer_individual_last_name
  end

  private

  def tribunal_case
    __getobj__
  end
end
