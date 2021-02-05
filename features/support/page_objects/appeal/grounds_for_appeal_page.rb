class GroundsForAppealPage < BasePage
  set_url '/steps/details/grounds_for_appeal'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Grounds for appeal'
    element :textarea, '.govuk-textarea'
  end

  def valid_submission
    content.textarea.set 'Grounds for appeal text'
    continue_or_save_continue
  end
end
