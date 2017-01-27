class TaxpayerDetailsPresenter < BaseAnswersPresenter

  def name
    return tribunal_case.taxpayer_organisation_fao if tribunal_case.taxpayer_is_organisation?
    tribunal_case.taxpayer_individual_name
  end

  def phone
    tribunal_case.taxpayer_contact_phone
  end

  def address
    [
      tribunal_case.taxpayer_organisation_name,
      tribunal_case.taxpayer_contact_address,
      tribunal_case.taxpayer_contact_postcode
    ].compact.join("\n")
  end

  def email
    tribunal_case.taxpayer_contact_email
  end
end
