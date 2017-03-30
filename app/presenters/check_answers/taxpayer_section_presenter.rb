module CheckAnswers
  class TaxpayerSectionPresenter < SectionPresenter
    def name
      :taxpayer
    end

    def answers
      [
        taxpayer_details_answer,
        representative_details_answer,
        Answer.new(:representative_professional_status, tribunal_case.representative_professional_status, change_path: edit_steps_details_representative_professional_status_path),
        # nil because there is no value
        FileOrTextAnswer.new(:representative_approval, nil, tribunal_case.documents(:representative_approval).first, change_path: edit_steps_details_representative_approval_path)
      ].select(&:show?)
    end

    private

    def taxpayer_details_answer
      ContactDetailsAnswer.new(
        :taxpayer_details,
        individual_first_name: tribunal_case.taxpayer_individual_first_name,
        individual_last_name: tribunal_case.taxpayer_individual_last_name,
        contact_address: tribunal_case.taxpayer_contact_address,
        contact_postcode: tribunal_case.taxpayer_contact_postcode,
        contact_email: tribunal_case.taxpayer_contact_email,
        contact_phone: tribunal_case.taxpayer_contact_phone,
        organisation_name: tribunal_case.taxpayer_organisation_name,
        organisation_fao: tribunal_case.taxpayer_organisation_fao,
        organisation_registration_number: tribunal_case.taxpayer_organisation_registration_number,
        change_path: edit_steps_details_taxpayer_type_path
      )
    end

    def representative_details_answer
      if tribunal_case.has_representative == HasRepresentative::YES
        ContactDetailsAnswer.new(
          :representative_details,
          individual_first_name: tribunal_case.representative_individual_first_name,
          individual_last_name: tribunal_case.representative_individual_last_name,
          contact_address: tribunal_case.representative_contact_address,
          contact_postcode: tribunal_case.representative_contact_postcode,
          contact_email: tribunal_case.representative_contact_email,
          contact_phone: tribunal_case.representative_contact_phone,
          organisation_name: tribunal_case.representative_organisation_name,
          organisation_fao: tribunal_case.representative_organisation_fao,
          organisation_registration_number: tribunal_case.representative_organisation_registration_number,
          change_path: edit_steps_details_representative_type_path
        )
      else
        Answer.new(:representative_details, :no_representative, change_path: edit_steps_details_has_representative_path)
      end
    end
  end
end