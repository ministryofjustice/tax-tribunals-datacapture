class CaseCreator
  attr_reader :tribunal_case, :errors

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
    @errors = []
  end

  def call
    begin
      glimr_case = GlimrNewCase.new(tribunal_case).call!
      case_reference = glimr_case.case_reference

      tribunal_case.update(
        case_reference: case_reference,
        case_status: CaseStatus::SUBMITTED
      )
    rescue => ex
      errors << ex.message
    end

    self
  end

  def success?
    !errors?
  end

  def errors?
    errors.any?
  end
end
