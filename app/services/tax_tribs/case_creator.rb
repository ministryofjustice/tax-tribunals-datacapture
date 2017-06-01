module TaxTribs
  class CaseCreator
    attr_reader :tribunal_case

    def initialize(tribunal_case)
      @tribunal_case = tribunal_case
    end

    def call
      tribunal_case.update(
        case_status: CaseStatus::SUBMIT_IN_PROGRESS
      )

      glimr_case = GlimrNewCase.new(tribunal_case).call
      case_reference = glimr_case.case_reference

      # case_reference could be nil, if GLiMR call failed, but despite this,
      # we want to mark the tribunal case as `submitted`
      tribunal_case.update(
        case_reference: case_reference,
        case_status: CaseStatus::SUBMITTED
      )
    end
  end
end
