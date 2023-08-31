module Steps::Details
  class RepresentativeOrganisationDetailsForm < RepresentativeDetailsForm
    attribute :representative_organisation_name, String
    attribute :representative_organisation_fao, String

    validates_presence_of :representative_organisation_name,
                          :representative_organisation_fao

    def name_fields
      [:representative_organisation_name]
    end

    def show_fao?
      true
    end

    def show_registration_number?
      false
    end

    private

    def persist!
      super(
        representative_organisation_name:,
        representative_organisation_fao:
      )
    end
  end
end
