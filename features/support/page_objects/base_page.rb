class BasePage < SitePrism::Page

  section :cookie, '.govuk-cookie-banner' do
    element :header, 'h2', text: 'Cookies on appeal to the tax tribunal'
    element :accept_button, "input[value='Accept analytics cookies']"
    element :reject_button, "input[value='Reject analytics cookies']"
  end

  section :content, '#main-content' do
    element :continue_button, "input[value='Continue']"
    element :save_continue_button, "input[value='Save and continue']"
    element :continue_or_save_continue, "input[type='submit']"
    element :save_button, "input[value='Save']"
    element :submit_button, "input[value='Submit']"
    element :individual, 'label', text: 'Individual'
    element :company, 'label', text: 'Company'
    element :other, 'label', text: 'Other type of organisation'
    element :yes_option, 'label', text: 'Yes'
    element :no_option, 'label', text: 'No'
    element :save_and_come_back_link, 'a', text: 'Save and come back later'
  end
  section :footer, '.govuk-footer' do
    element :help_link, 'a', text: 'Help'
    element :contact_link, 'a', text: 'Contact'
    element :cookies_link, 'a', text: 'Cookies'
    element :terms_link, 'a', text: 'Terms and conditions'
    element :privacy_link, 'a', text: 'Privacy policy'
    element :accessibility_link, 'a', text: 'Accessibility statement'
  end
  element :back_button, '.govuk-back-link'
end
