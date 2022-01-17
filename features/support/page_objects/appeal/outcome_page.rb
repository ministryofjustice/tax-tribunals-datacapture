class OutcomePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/outcome'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.outcome.edit.heading')
    element :textarea, '.govuk-textarea'
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def valid_submission
    content.textarea.set 'Outcome'
    continue_or_save_continue
  end
end
