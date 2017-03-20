class RepresentativeDetailsPresenter < BaseAnswersPresenter
  def present?
    tribunal_case.has_representative == HasRepresentative::YES
  end

  def name
    return tribunal_case.representative_organisation_fao if tribunal_case.representative_is_organisation?
    [tribunal_case.representative_individual_first_name, tribunal_case.representative_individual_last_name].join(' ')
  end

  def phone
    tribunal_case.representative_contact_phone
  end

  def address
    [
      tribunal_case.representative_organisation_name,
      tribunal_case.representative_contact_address,
      tribunal_case.representative_contact_postcode
    ].compact.join("\n")
  end

  def email
    tribunal_case.representative_contact_email
  end

  def proforma_present?
    tribunal_case.documents(:representative_approval).any?
  end
end
