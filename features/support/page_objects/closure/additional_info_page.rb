class AdditionalInfoPage < BasePage
  set_url '/steps/closure/additional_info'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Why should the enquiry close? (optional)'
    element :text_area, '.govuk-textarea'
  end
end
