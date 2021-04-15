class SendTaxpayerCopyPage < BasePage
  set_url '/en/steps/details/send_taxpayer_copy'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.send_taxpayer_copy.question')
    element :email_field, "input[name='steps_details_send_application_details_form[email_address]']"
    element :not_matching_error_message, 'a', text: I18n.t('activemodel.errors.models.steps/details/send_application_details_form.attributes.email_address.different_taxpayer')
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
