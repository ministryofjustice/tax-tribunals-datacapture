class EnquiryDetailsPage < BasePage
  set_url '/en/steps/closure/enquiry_details'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.closure.enquiry_details.edit.heading')
    element :reference_number_input, "input[name='steps_closure_enquiry_details_form[closure_hmrc_reference]']"
    element :years_input, "input[name='steps_closure_enquiry_details_form[closure_years_under_enquiry]']"
    element :tax_officer_input, "input[name='steps_closure_enquiry_details_form[closure_hmrc_officer]']"
    section :error_summary, '.govuk-error-summary__body' do
      element :reference_number_error, 'a', text: I18n.t('activemodel.errors.models.steps/closure/enquiry_details_form.attributes.closure_hmrc_reference.blank')
      element :years_error, 'a', text: I18n.t('activemodel.errors.models.steps/closure/enquiry_details_form.attributes.closure_years_under_enquiry.blank')
    end
  end

  def valid_submission
    content.reference_number_input.set "AB12"
    content.years_input.set "1"
    continue_or_save_continue
  end
end
