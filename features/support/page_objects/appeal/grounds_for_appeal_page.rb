class GroundsForAppealPage < BasePage
  set_url '/en/steps/details/grounds_for_appeal'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.grounds_for_appeal.edit.page_title')
    element :textarea, '.govuk-textarea'
  end

  def valid_submission
    content.textarea.set 'Grounds for appeal text'
    continue_or_save_continue
  end
end
