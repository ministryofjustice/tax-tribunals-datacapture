class ClosurePage < BasePage
  set_url '/closure'

  section :content, '#content' do
    element :header, 'h1', text: 'Apply to close an enquiry'
    element :continue_button, '.button', text: 'Continue'
  end

  def continue
    content.continue_button.click
  end
end