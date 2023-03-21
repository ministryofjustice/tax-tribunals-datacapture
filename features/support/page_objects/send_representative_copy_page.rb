class SendRepresentativeCopyPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/send_representative_copy'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.send_representative_copy.question')
    element :email_option, 'label', text: I18n.t('dictionary.CONTACT_PREFERENCES.email')
    element :email_field, "input[name='steps_details_send_application_details_form[email_address]']"
    element :not_matching_error_message, 'a', text: I18n.t('activemodel.errors.models.steps/details/send_application_details_form.attributes.email_address.different_representative')
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def submit_email_and_a_valid_email
    content.email_option.click
    content.email_field.set 'matching@email.com'
    continue_or_save_continue
  end

  def submit_email_and_a_invalid_email
    content.email_option.click
    content.email_field.set 'non-matching@email.com'
    continue_or_save_continue
  end
end
