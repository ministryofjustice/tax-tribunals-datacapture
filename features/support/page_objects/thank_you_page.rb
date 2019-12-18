class ThankYouPage < BasePage
  set_url '/surveys/feedback/thanks'

  section :content, '#content' do
    element :header, 'h1', text: 'Thank you for reporting this problem'
    element :contact_via_email, 'p', text: 'We will contact you on your email shortly.'
    element :continue_button, '.button', text: 'Back to start'
  end
end