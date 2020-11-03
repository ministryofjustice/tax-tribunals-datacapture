class BasePage < SitePrism::Page
  section :content, '#main-content' do
    element :continue_button, "input[value='Continue']"
    element :save_continue_button, "input[value='Save and continue']"
    element :save_button, "input[value='Save']"
    element :individual, 'label', text: 'Individual'
    element :company, 'label', text: 'Company'
    element :other, 'label', text: 'Other type of organisation'
  end
end
