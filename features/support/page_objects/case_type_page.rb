class CaseTypePage < BasePage
  set_url '/steps/closure/case_type'

  section :content, '#content' do
    element :header, 'h1', text: 'What type of enquiry do you want to close?'
  end
end
