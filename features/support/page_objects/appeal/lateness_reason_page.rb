class LatenessReasonPage < BasePage
  set_url '/steps/lateness/lateness_reason'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Why are you late with your appeal?'
    element :textarea, '.govuk-textarea'
  end

  def valid_submission
    content.textarea.set 'Reason for lateness'
    continue_or_save_continue
  end
end
