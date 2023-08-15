class SendTaxpayerCopyPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/send_taxpayer_copy'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.send_taxpayer_copy.question')
    element :email_option, 'label', text: I18n.t('dictionary.CONTACT_PREFERENCES.email')
    element :email_field, "input[name='steps_details_send_application_details_form[email_address]']"
    element :phone_field, "input[name='steps_details_send_application_details_form[phone_number]']"
    element :no_contact_option, 'label', text: I18n.t('dictionary.CONTACT_PREFERENCES.none')
    element :both_option, 'label', text: I18n.t('dictionary.CONTACT_PREFERENCES.both')
    element :text_option, 'label', text: I18n.t('dictionary.CONTACT_PREFERENCES.text')
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
      element :not_matching_error_message, 'a', text: I18n.t('activemodel.errors.models.steps/details/send_application_details_form.attributes.email_address.different_taxpayer')
      # element :not_matching_phone_message, 'a', text: I18n.t('activemodel.errors.models.steps/details/send_application_details_form.attributes.phone_number.different_taxpayer')
    end
  end

  def submit_email_and_valid_email
    content.email_option.click
    content.email_field.set 'matching@email.com'
    continue_or_save_continue
  end

  def submit_email_and_invalid_email
    content.email_option.click
    content.email_field.set 'non-matching@email.com'
    continue_or_save_continue
  end

  def submit_no_contact
    content.no_contact_option.click
    continue_or_save_continue
  end

  def submit_email_only
    content.both_option.click
    content.email_field.set 'matching@email.com'
    continue_or_save_continue
  end

  def blank_phone_option
    content.text_option.click
    continue_or_save_continue
  end

  def submit_valid_phone
    content.phone_field.set '(00000000000)'
    continue_or_save_continue
  end
end
