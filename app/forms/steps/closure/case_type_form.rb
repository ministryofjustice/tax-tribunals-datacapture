module Steps::Closure
  class CaseTypeForm < BaseForm
    attribute :closure_case_type, String

    def self.choices
      ClosureCaseType.values.map(&:to_s)
    end
    validates_inclusion_of :closure_case_type, in: choices

    private

    def closure_case_type_value
      ClosureCaseType.new(closure_case_type)
    end

    def changed?
      tribunal_case.closure_case_type != closure_case_type_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      tribunal_case.update(
        closure_case_type: closure_case_type_value
        # The following are dependent attributes that need to be reset
      )
    end
  end
end
