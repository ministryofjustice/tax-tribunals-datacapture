module Steps::Details
  class RepresentativeCompanyDetailsForm < RepresentativeDetailsForm
    attribute :representative_organisation_name, String
    attribute :representative_organisation_registration_number, String
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
      true
    end

    private

    def persist!
      super(
        representative_organisation_name:                representative_organisation_name,
        representative_organisation_registration_number: representative_organisation_registration_number,
        representative_organisation_fao:                 representative_organisation_fao
      )
    end
  end
end
