class EnquiryDetailsPage < BasePage
  set_url '/steps/closure/enquiry_details'

  section :content, '#content' do
    element :header, 'h1', text: 'Enquiry details'
    element :hmrc_reference_number_label, 'label', text: 'HMRC reference number'
    element :hmrc_reference_number_input, '#steps_closure_enquiry_details_form_closure_hmrc_reference'
    element :years_under_enquiry_label, 'label', text: 'Years under enquiry'
    element :years_under_enquiry_input, '#steps_closure_enquiry_details_form_closure_years_under_enquiry'
    element :tax_office_label, 'label', text: 'Name of the tax officer running the enquiry (optional)'
    element :tax_office_input, '#steps_closure_enquiry_details_form_closure_hmrc_officer'
  end

  def successfully_submit_enquiry_details
    content.hmrc_reference_number_input.set '12345'
    content.years_under_enquiry_input.set '3 and a half'
    content.tax_office_input.set 'John R Smith'
    base_page.continue
  end
end

