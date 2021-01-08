module Steps::Details
  class RepresentativeDetailsForm < BaseForm
    attribute :representative_contact_address, StrippedString
    attribute :representative_contact_postcode, StrippedString
    attribute :representative_contact_city, StrippedString
    attribute :representative_contact_country, StrippedString
    attribute :representative_contact_email, NormalisedEmail
    attribute :representative_contact_phone, StrippedString

    validates_presence_of :representative_contact_address,
                          :representative_contact_postcode,
                          :representative_contact_city,
                          :representative_contact_country

    validates :representative_contact_email, 'valid_email_2/email': true, if: :should_validate_email

    private

    delegate :started_by_representative?, to: :tribunal_case

    def should_validate_email
      return false unless started_by_representative_or_present?
      special_chars_in_mail.blank? && email_too_long.blank?
    end

    def started_by_representative_or_present?
      started_by_representative? || representative_contact_email.present?
    end

    def special_chars_in_mail
      return if representative_contact_email.blank?

      if representative_contact_email =~ /[;&()!\/*]/i
        errors.add :representative_contact_email, I18n.t('errors.messages.email.special_characters')
      end
    end

    def email_too_long
      return if representative_contact_email.blank?
      if representative_contact_email.length > 256
        errors.add :representative_contact_email, I18n.t('errors.messages.email.too_long')
      end
    end

    def persist!(additional_attributes)
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update({
        representative_contact_address:  representative_contact_address,
        representative_contact_postcode: representative_contact_postcode,
        representative_contact_city:     representative_contact_city,
        representative_contact_country:  representative_contact_country,
        representative_contact_email:    representative_contact_email,
        representative_contact_phone:    representative_contact_phone
      }.merge(additional_attributes))
    end
  end
end
