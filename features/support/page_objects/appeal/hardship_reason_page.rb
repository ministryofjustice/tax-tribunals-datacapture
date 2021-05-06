class HardshipReasonPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/hardship/hardship_reason'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.hardship.hardship_reason.edit.heading')
    element :reason_textarea, '#steps-hardship-hardship-reason-form-hardship-reason-field'
  end

  def submit_reason
    content.reason_textarea.set 'Reason'
    continue_or_save_continue
  end
end
