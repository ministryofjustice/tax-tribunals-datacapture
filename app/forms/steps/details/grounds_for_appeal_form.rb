module Steps::Details
  class GroundsForAppealForm < BaseForm
    attribute :grounds_for_appeal, String

    # TODO: Add any further validations here

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        grounds_for_appeal: grounds_for_appeal
      )
    end
  end
end
