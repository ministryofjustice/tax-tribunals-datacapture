module Steps::Details
  class RepresentativeIndividualDetailsForm < RepresentativeDetailsForm
    attribute :representative_individual_first_name, String
    attribute :representative_individual_last_name, String

    validates_presence_of :representative_individual_first_name,
                          :representative_individual_last_name

    def name_fields
      [:representative_individual_first_name, :representative_individual_last_name]
    end

    def show_fao?
      false
    end

    def show_registration_number?
      false
    end

    private

    def persist!
      super(
        representative_individual_first_name: representative_individual_first_name,
        representative_individual_last_name: representative_individual_last_name
      )
    end
  end
end
