module Steps::Details
  class SendApplicationDetailsForm < BaseForm
    TRIBUNAL_CASE_ENTITY_MAPPING = {
      UserType::TAXPAYER       => :send_taxpayer_copy,
      UserType::REPRESENTATIVE => :send_representative_copy
    }

    attribute :send_application_details, String
    attribute :email_address, NormalisedEmail
    attr_accessor :send_to

    def self.choices
      SendApplicationDetails.values.map(&:to_s)
    end

    validate :selected_option
    validates_presence_of :email_address, if: :send_copy?

    # rubocop:disable LiteralAsCondition
    validate :email_address_identical, if: :send_copy?
    # rubocop:enable LiteralAsCondition

    def send_copy?
      send_application_details&.to_s == 'yes'
    end

    private

    def selected_option
      if not self.class.choices.include?(send_application_details)
        errors.add(:send_application_details, tribunal_case_entity, message: 'should you receive an emailed copy?')
      end
    end

    def email_address_identical
      return unless errors.blank?
      if saved_email != email_address
        key = "different_#{send_to}".to_sym
        errors.add(:email_address, key, message: "#{send_to}'s email does not match entered email address")
      end
    end

    def saved_email
      if send_to == UserType::TAXPAYER
        tribunal_case.taxpayer_contact_email
      else
        tribunal_case.representative_contact_email
      end
    end

    def send_application_details_value
      SendApplicationDetails.new(send_application_details)
    end

    def tribunal_case_entity
      TRIBUNAL_CASE_ENTITY_MAPPING[send_to]
    end

    def tribunal_case_entity_value
      tribunal_case.send(tribunal_case_entity)
    end

    def changed?
      tribunal_case_entity_value != send_application_details_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      # or send_representative_copy: send_application_details_value
      tribunal_case.update(
        tribunal_case_entity => send_application_details_value
     )
    end
  end
end
