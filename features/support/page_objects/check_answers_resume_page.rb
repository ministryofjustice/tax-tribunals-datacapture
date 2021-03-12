class CheckAnswersResumePage < BasePage
  set_url '/en/steps/details/check_answers/resume'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Resume your appeal'
    element :change_link, '.govuk-link', text: 'Change'
  end

  def change
    content.change_link.click
  end
end
