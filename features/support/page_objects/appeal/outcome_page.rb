class OutcomePage < BasePage
  set_url '/en/steps/details/outcome'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.outcome.edit.heading')
    element :textarea, '.govuk-textarea'
  end

  def valid_submission
    content.textarea.set 'Outcome'
    continue_or_save_continue
  end
end
