module Steps::Shared
  class WhatSupportForm < BaseForm
    attribute :language_interpreter, Boolean
    attribute :language_interpreter_details, String
    attribute :sign_language_interpreter, Boolean
    attribute :sign_language_interpreter_details, String
    attribute :hearing_loop, Boolean
    attribute :disabled_access, Boolean
    attribute :other_support, Boolean
    attribute :other_support_details, String

    validates_presence_of  :language_interpreter_details, if: :language_interpreter?
    validates_presence_of  :sign_language_interpreter_details, if: :sign_language_interpreter?
    validates_presence_of  :other_support_details, if: :other_support?
    validate :at_least_one_checkbox_validation

    def save
      coerce_values
      super
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        attributes_map.merge(
          language_interpreter_details: (language_interpreter_details if language_interpreter?),
          sign_language_interpreter_details: (sign_language_interpreter_details if sign_language_interpreter?),
          other_support_details: (other_support_details if other_support?)
        )
      )
    end

    def attributes_map
      attribute_set.map {|attr| [attr.name, coerce_value(attr)] }.to_h
    end

    def coerce_value(attr)
      return true if attr.is_a?(Virtus::Attribute::Boolean) && !self[attr.name].blank?

      self[attr.name]
    end

    def coerce_values
      self.attributes = attributes_map
    end

    def at_least_one_checkbox_validation
      return if any_answers?
      i18n_scope = 'activemodel.errors.models.steps/shared/what_support_form.attributes'
      errors.add(:what_support, I18n.t('what_support', scope: i18n_scope))
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
