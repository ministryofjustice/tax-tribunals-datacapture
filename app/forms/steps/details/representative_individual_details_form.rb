module Steps::Details
  class RepresentativeIndividualDetailsForm < RepresentativeDetailsForm
    attribute :representative_individual_first_name, String
    attribute :representative_individual_last_name, String

    validates_presence_of :representative_individual_first_name,
                          :representative_individual_last_name

    validates :representative_individual_first_name,
              length: { maximum: 256, message: I18n.t("errors.messages.name.too_long") }
    validates :representative_individual_last_name,
              length: { maximum: 256, message: I18n.t("errors.messages.name.too_long") }

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

    def name_length
      name_fields.each do |name_field|
        if send(name_field).length > 256
          errors.add name_field, I18n.t("errors.messages.name.too_long")
        end
      end
    end

    def persist!
      super(
        representative_individual_first_name: representative_individual_first_name,
        representative_individual_last_name: representative_individual_last_name
      )
    end
  end
end
