class OutcomePage < BasePage
  set_url '/steps/details/outcome'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Briefly say what outcome you would like'
    element :textarea, '.govuk-textarea'
  end

  def valid_submission
    content.textarea.set 'Outcome'
    continue
  end
end
