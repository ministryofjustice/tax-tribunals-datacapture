class AppealHomePage < BasePage
  set_url '/appeal'

  section :content, '#content' do
    element :appeal_decision_link, 'a', text: 'Appeal against a tax decision'
    element :continue_button, '.button', text: 'Continue'
  end

  def continue
    content.continue_button.click
  end
end
