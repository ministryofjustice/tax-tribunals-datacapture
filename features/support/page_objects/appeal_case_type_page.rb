class AppealCaseTypePage < BasePage
  set_url '/steps/appeal/case_type'

  section :content, '#content' do
    element :header, 'h1', text: 'What is your appeal about?'
    section :error, '.error-summary' do
      element :error_heading, '.error-summary-heading', text: 'There is a problem'
      element :error_link, 'a', text: 'Select what your appeal is about'
    end
  end
end