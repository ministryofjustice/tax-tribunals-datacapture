module Steps::Lateness
  class LatenessReasonForm < BaseForm
    attribute :lateness_reason, String

    validates_length_of :lateness_reason, minimum: 5

    def lateness_unknown?
      tribunal_case.in_time == InTime::UNSURE
    end

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      tribunal_case.update(lateness_reason: lateness_reason)
    end
  end
end
