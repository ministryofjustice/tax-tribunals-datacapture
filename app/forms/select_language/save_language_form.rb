module SelectLanguage
  class SaveLanguageForm < BaseForm
    attribute :language, String

    def self.choices
      Language.values.map(&:to_s)
    end

    validates_inclusion_of :language, in: choices

    private

    def language_value
      Language.new(language)
    end

    def changed?
      tribunal_case.language != language_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        language: language_value
      )
    end
  end
end
