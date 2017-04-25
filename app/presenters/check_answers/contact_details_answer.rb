module CheckAnswers
  class ContactDetailsAnswer < Answer
    attr_reader :attributes

    def initialize(question, attributes={})
      super(question, nil, change_path: attributes[:change_path])
      @attributes = attributes
    end

    def show?
      display_name.strip.present?
    end

    # Used by Rails to determine which partial to render
    def to_partial_path
      'contact_details_row'
    end

    def contact_address
      [
        display_name,
        attributes[:organisation_name],
        organisation_registration_number,
        attributes[:contact_address],
        attributes[:contact_postcode]
      ].compact.join("\n")
    end

    def extra_details?
      phone? || email? || organisation_registration_number?
    end

    def phone?
      phone.present?
    end

    def phone
      attributes[:contact_phone]
    end

    def email?
      email.present?
    end

    def email
      attributes[:contact_email]
    end

    def organisation_registration_number?
      organisation_registration_number.present?
    end

    def organisation_registration_number
      attributes[:organisation_registration_number]
    end

    private

    def display_name
      if attributes[:organisation_fao]
        attributes[:organisation_fao]
      else
        [
          attributes[:individual_first_name],
          attributes[:individual_last_name]
        ].join(' ')
      end
    end
  end
end
