module Steps::Details
  class OutcomeForm < BaseForm
    attribute :outcome, String

    validates_length_of :outcome, minimum: 10

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(outcome: outcome)
    end
  end
end
