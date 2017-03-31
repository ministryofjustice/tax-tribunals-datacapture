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

    def pdf_params
      { pdf: pdf_filename, footer: { right: '[page]' } }
    end

    def pdf_filename
      [tribunal_case.case_reference, taxpayer_name_for_filename].compact.join('_').tr('/', '_')
    end

    private

    def pdf?
      format == :pdf
    end

    def taxpayer_name_for_filename
      [
        tribunal_case.taxpayer_individual_first_name,
        tribunal_case.taxpayer_individual_last_name,
        tribunal_case.taxpayer_organisation_name
      ].compact.join.gsub(/\s+/, '')
    end
  end
end
