class EnquiryDetailsPage < BasePage
  set_url '/steps/closure/enquiry_details'

  section :content, '#content' do
    element :header, 'h1', text: 'Enquiry details'
  end
end
