module Steps::Closure
  class EnquiryDetailsForm < BaseForm
    attribute :closure_hmrc_reference, String
    attribute :closure_hmrc_officer, String
    attribute :closure_years_under_enquiry, String

    validates_presence_of :closure_hmrc_reference,
                          :closure_years_under_enquiry

    validate :closure_years_in_range?

    private

    def closure_years_in_range?
      return if closure_years_under_enquiry.nil?
      return if closure_years_under_enquiry.scan(/\D/).empty? && (0..20).include?(closure_years_under_enquiry.to_i)

      errors.add(:closure_years_under_enquiry,
                 I18n.t('activemodel.errors.models.steps/closure/enquiry_details_form.attributes.closure_years_under_enquiry.blank'))
    end

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
