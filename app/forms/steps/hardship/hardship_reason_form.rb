module Steps::Hardship
  class HardshipReasonForm < BaseForm
    attribute :hardship_reason, String

    validates_length_of :hardship_reason, minimum: 5

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(hardship_reason: hardship_reason)
    end
  end
end
