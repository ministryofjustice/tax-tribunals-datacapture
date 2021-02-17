class SendTaxpayerCopyPage < BasePage
  set_url '/steps/details/send_taxpayer_copy'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Does the taxpayer want a copy of the case details sent by email?'
    element :email_field, "input[name='steps_details_send_application_details_form[email_address]']"
    element :not_matching_error_message, 'a', text: "Enter the same email address you provided for the taxpayer's details. Press back and change the taxpayer's email address if this is incorrect."
  end

  def submit_yes_and_valid_email
    base_page.content.yes_option.click
    content.email_field.set 'matching@email.com'
    continue_or_save_continue
  end

  def submit_yes_and_invalid_email
    base_page.content.yes_option.click
    content.email_field.set 'non-matching@email.com'
    continue_or_save_continue
  end
end
