module Steps::Closure
  class EnquiryDetailsForm < BaseForm
    attribute :closure_hmrc_reference, String
    attribute :closure_hmrc_officer, String
    attribute :closure_years_under_enquiry, String

    validates_presence_of :closure_hmrc_reference,
                          :closure_years_under_enquiry

    private

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        closure_hmrc_reference: closure_hmrc_reference,
        closure_hmrc_officer: closure_hmrc_officer,
        closure_years_under_enquiry: closure_years_under_enquiry
      )
    end
  end
end
