class CaseMailPresenter < SimpleDelegator
  # Initialise with a TribunalCase instance and any method not
  # defined in this class will be forwarded automatically to that instance.

  def case_reference_present?
    notify_presence_for(case_reference)
  end

  def case_reference_absent?
    notify_absence_for(case_reference)
  end

  # GOV.UK Notify does not accept `nil` values, instead use empty strings
  def case_reference
    tribunal_case.case_reference.to_s
  end

  def account_user_email
    tribunal_case.user.email
  end

  # Email address of whoever filled the form out first. If it's the representative,
  # they would get it, otherwise the taxpayer would
  def recipient_email
    started_by_representative? ? representative_contact_email : taxpayer_contact_email
  end

  def recipient_name
    started_by_representative? ? representative_contact_name : taxpayer_contact_name
  end

  def show_company_name?
    notify_presence_for(company_name)
  end

  # GOV.UK Notify does not accept `nil` values, instead use empty strings
  def company_name
    (started_by_representative? ? representative_organisation_name : taxpayer_organisation_name).to_s
  end

  def show_deadline_warning?
    intent.eql?(Intent::TAX_APPEAL) ? 'yes' : 'no'
  end

  # Email address to use for `GLiMR is down` notifications
  def ftt_recipient_email
    ENV.fetch('TAX_TRIBUNAL_EMAIL')
  end

  def survey_link
    Rails.configuration.survey_link
  end

  private

  def representative_contact_name
    return representative_organisation_fao if representative_is_organisation?
    [representative_individual_first_name, representative_individual_last_name].join(' ')
  end

  def taxpayer_contact_name
    return taxpayer_organisation_fao if taxpayer_is_organisation?
    [taxpayer_individual_first_name, taxpayer_individual_last_name].join(' ')
  end

  # GOV.UK Notify expects this to be literals
  def notify_presence_for(field)
    field.present? ? 'yes' : 'no'
  end

  # GOV.UK Notify expects this to be literals
  def notify_absence_for(field)
    field.blank? ? 'yes' : 'no'
  end

  def tribunal_case
    __getobj__
  end
end
