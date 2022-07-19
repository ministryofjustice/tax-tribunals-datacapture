class TaxTribs::RebuildPdf
  STATUS = TaxTribs::GroverPdf::STATUS

  def self.rebuild
    TribunalCase.where.not(pdf_generation_status: nil).each do |tc|
      build(tc)
    end
  end

  def self.build(tribunal_case)
    controller = controller_for(tribunal_case)
    presenter = controller.new.presenter_class

    TaxTribs::CaseDetailsPdf
      .new(tribunal_case, controller, presenter)
      .generate_and_upload
  end

  def self.controller_for(tribunal_case)
    if tribunal_case.pdf_generation_status.match(/APPEAL/)
      AppealCasesController
    elsif tribunal_case.pdf_generation_status.match(/CLOSURE/)
      ClosureCasesController
    elsif tribunal_case.pdf_generation_status.present?
      raise StandardError, "Pdf generation status #{
          tribunal_case.pdf_generation_status} not found"
    end
  end
end