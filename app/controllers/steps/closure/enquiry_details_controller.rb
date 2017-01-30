module Steps::Closure
  class EnquiryDetailsController < Steps::ClosureStepController
    def edit
      super
      @form_object = EnquiryDetailsForm.new(
        tribunal_case: current_tribunal_case,
        closure_hmrc_reference: current_tribunal_case.closure_hmrc_reference,
        closure_hmrc_officer: current_tribunal_case.closure_hmrc_officer,
        closure_years_under_enquiry: current_tribunal_case.closure_years_under_enquiry
      )
    end

    def update
      update_and_advance(EnquiryDetailsForm, as: :enquiry_details)
    end
  end
end
