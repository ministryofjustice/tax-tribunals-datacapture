class CheckAnswersResumePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/check_answers/resume'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.CYA_CONFIRMATION.check_answers.resume.heading_appeal')
    element :change_link, '.govuk-link', text: I18n.t('check_answers.change')
  end

  def change
    content.change_link.click
  end
end
