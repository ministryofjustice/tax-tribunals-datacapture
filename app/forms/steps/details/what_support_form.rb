module Steps::Details
  class WhatSupportForm < BaseForm

    attribute :language_interpreter, Boolean
    attribute :sign_language_interpreter, Boolean
    attribute :hearing_loop, Boolean
    attribute :disabled_access, Boolean
    attribute :other_support, Boolean
    attribute :other_support_details, String

    validates_presence_of  :other_support_details, if: :other_support?
    validate :at_least_one_checkbox_validation

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        attributes_map.merge(
            other_support_details: (other_support_details if other_support?)
          )
      )
    end

    def attributes_map
      attribute_set.map { |attr| [attr.name, self[attr.name]] }.to_h
    end

    def at_least_one_checkbox_validation
      errors.add(:what_support, "Select what support you need at the hearing") unless any_answers?
    end

    def any_answers?
      language_interpreter ||
      sign_language_interpreter ||
      hearing_loop ||
      disabled_access ||
      other_support
    end
  end
end
