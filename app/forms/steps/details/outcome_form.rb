module Steps::Details
  class OutcomeForm < BaseForm
    attribute :outcome, String

    validates_presence_of :outcome

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(outcome:)
    end
  end
end
