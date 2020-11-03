class AppealHomePage < BasePage
  set_url '/appeal'

  section :content, '#main-content' do
    element :appeal_decision_link, 'a', text: 'Appeal against a tax decision'
    element :continue_button, '.govuk-button', text: 'Continue'
    element :header, 'h2', text: 'Appeal against a tax decision'
  end

  def continue
    content.continue_button.click
  end
end
