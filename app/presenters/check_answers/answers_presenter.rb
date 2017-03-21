module CheckAnswers
  class AnswersPresenter
    attr_reader :tribunal_case, :format

    def initialize(tribunal_case, format: :html)
      @tribunal_case = tribunal_case
      @format = format
    end

    def case_reference?
      case_reference.present?
    end

    def case_reference
      tribunal_case.case_reference
    end

    private

    def pdf?
      format == :pdf
    end
  end
end
