module Steps::Hardship
  class HardshipReviewRequestedForm < BaseForm
    attribute :hardship_review_requested, String

    def self.choices
      HardshipReviewRequested.values.map(&:to_s)
    end
    validates_inclusion_of :hardship_review_requested, in: choices

    private

    def hardship_review_requested_value
      HardshipReviewRequested.new(hardship_review_requested)
    end

    def changed?
      tribunal_case.hardship_review_requested != hardship_review_requested_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        hardship_review_requested: hardship_review_requested_value,
        # The following are dependent attributes that need to be reset
        hardship_review_status: nil
      )
    end
  end
end
