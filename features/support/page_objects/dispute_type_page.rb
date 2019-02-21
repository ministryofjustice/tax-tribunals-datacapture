class DisputeTypePage < BasePage
  set_url '/steps/appeal/dispute_type'

  section :content, '#content' do
    element :header, 'h1', text: 'What is your dispute about?'
    element :continue_button, "input[value='Save and continue']"
  end

  def continue
    content.continue_button.click
  end
end