module Steps::Hardship
  class HardshipReviewStatusForm < BaseForm
    attribute :hardship_review_status, String

    def self.choices
      HardshipReviewStatus.values
    end
    validates_inclusion_of :hardship_review_status, in: choices.map(&:to_s)

    private

    def hardship_review_status_value
      HardshipReviewStatus.new(hardship_review_status)
    end

    def changed?
      tribunal_case.hardship_review_status != hardship_review_status_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        hardship_review_status: hardship_review_status_value
      )
    end
  end
end
