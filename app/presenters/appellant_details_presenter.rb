class AppellantDetailsPresenter < BaseAnswersPresenter

  def name
    return tribunal_case.taxpayer_company_fao if tribunal_case.company?
    tribunal_case.taxpayer_individual_name
  end

  def phone
    tribunal_case.taxpayer_contact_phone
  end

  def address
    [
      tribunal_case.taxpayer_company_name,
      tribunal_case.taxpayer_contact_address,
      tribunal_case.taxpayer_contact_postcode
    ].compact.join("\n")
  end

  def email
    tribunal_case.taxpayer_contact_email
  end
end
