class NeedSupportPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/need_support'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.need_support.question')
  section :error, '.govuk-error-summary' do
    element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
  end
    end
end
