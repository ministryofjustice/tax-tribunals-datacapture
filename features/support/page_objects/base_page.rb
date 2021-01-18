class BasePage < SitePrism::Page
  section :content, '#main-content' do
    element :continue_button, "input[value='Continue']"
    element :save_continue_button, "input[value='Save and continue']"
    element :save_button, "input[value='Save']"
    element :submit_button, "input[value='Submit']"
    element :individual, 'label', text: 'Individual'
    element :company, 'label', text: 'Company'
    element :other, 'label', text: 'Other type of organisation'
    element :yes_option, 'label', text: 'Yes'
    element :no_option, 'label', text: 'No'
  end
  section :footer, '.govuk-footer' do
    element :help_link, 'a', text: 'Help'
    element :contact_link, 'a', text: 'Contact'
    element :cookies_link, 'a', text: 'Cookies'
    element :terms_link, 'a', text: 'Terms and conditions'
    element :privacy_link, 'a', text: 'Privacy policy'
    element :accessibility_link, 'a', text: 'Accessibility statement'
  end
end
