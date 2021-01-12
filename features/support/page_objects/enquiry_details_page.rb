class EnquiryDetailsPage < BasePage
  set_url '/steps/closure/enquiry_details'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Enquiry details'
    element :reference_number_input, '#steps-closure-enquiry-details-form-closure-hmrc-reference-field'
    element :years_input, '#steps-closure-enquiry-details-form-closure-years-under-enquiry-field'
    element :tax_officer_input, '#steps-closure-enquiry-details-form-closure-hmrc-officer-field'
  end

  def valid_submission
    content.reference_number_input.set "AB12"
    content.years_input.set "1"
    content.tax_officer_input.set "John Smith"
    continue
  end
end
