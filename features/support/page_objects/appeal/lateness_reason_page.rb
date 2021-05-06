class LatenessReasonPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/lateness/lateness_reason'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('helpers.label.steps_lateness_lateness_reason_form.heading')
    element :textarea, '.govuk-textarea'
  end

  def valid_submission
    content.textarea.set 'Reason for lateness'
    continue_or_save_continue
  end
end
