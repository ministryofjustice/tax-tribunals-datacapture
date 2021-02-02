module Steps::Details
  class TaxpayerDetailsForm < BaseForm
    attribute :taxpayer_contact_address, StrippedString
    attribute :taxpayer_contact_postcode, StrippedString
    attribute :taxpayer_contact_city, StrippedString
    attribute :taxpayer_contact_country, StrippedString
    attribute :taxpayer_contact_email, NormalisedEmail
    attribute :taxpayer_contact_phone, StrippedString

    validates_presence_of :taxpayer_contact_address,
                          :taxpayer_contact_postcode,
                          :taxpayer_contact_city,
                          :taxpayer_contact_country

    validate :special_chars_in_mail if :started_by_taxpayer_or_present?
    validate :email_too_long if :started_by_taxpayer_or_present?
    validates :taxpayer_contact_email, presence: true, 'valid_email_2/email': true, if: :extra_email_validation?
    private

    def started_by_taxpayer_or_present?
      started_by_taxpayer? || taxpayer_contact_email.present?
    end

    def extra_email_validation?
      started_by_taxpayer_or_present? && errors.details[:taxpayer_contact_email].blank?
    end

    def special_chars_in_mail
      return if taxpayer_contact_email.blank?

      if taxpayer_contact_email =~ /[;&()!\/*]/i
        errors.add :taxpayer_contact_email, I18n.t('errors.messages.email.special_characters')
      end
    end

    def email_too_long
      return if taxpayer_contact_email.blank?
      if taxpayer_contact_email.length > 256
        errors.add :taxpayer_contact_email, I18n.t('errors.messages.email.too_long')
      end
    end

    def started_by_taxpayer?
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.started_by_taxpayer?
    end

    def persist!(additional_attributes)
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update({
        taxpayer_contact_address:  taxpayer_contact_address,
        taxpayer_contact_postcode: taxpayer_contact_postcode,
        taxpayer_contact_city:     taxpayer_contact_city,
        taxpayer_contact_country:  taxpayer_contact_country,
        taxpayer_contact_email:    taxpayer_contact_email,
        taxpayer_contact_phone:    taxpayer_contact_phone
      }.merge(additional_attributes))
    end
  end
end
