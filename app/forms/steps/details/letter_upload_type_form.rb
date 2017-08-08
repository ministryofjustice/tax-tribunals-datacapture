module Steps::Details
  class LetterUploadTypeForm < BaseForm
    attribute :letter_upload_type, String

    def self.choices
      LetterUploadType.values.map(&:to_s)
    end
    validates_inclusion_of :letter_upload_type, in: choices

    private

    def letter_upload_type_value
      LetterUploadType.new(letter_upload_type)
    end

    def changed?
      tribunal_case.letter_upload_type != letter_upload_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        letter_upload_type: letter_upload_type_value
      )
    end
  end
end
