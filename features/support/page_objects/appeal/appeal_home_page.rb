class AppealPage < BasePage
  set_url '/appeal'

  section :content, '#main-content' do
    element :header, 'h2', text: 'Appeal against a tax decision'
    element :continue_button, 'a', text: 'Continue'
  end

  def continue
    content.continue_button.click
  end
end
