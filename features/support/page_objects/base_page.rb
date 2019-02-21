class BasePage < SitePrism::Page
  section :content, '#content' do
    element :continue_button, "input[value='Continue']"
    element :save_continue_button, "input[value='Save and continue']"
  end

  def continue
    content.continue_button.click
  end

  def save_and_continue
    content.save_continue_button.click
  end
end
