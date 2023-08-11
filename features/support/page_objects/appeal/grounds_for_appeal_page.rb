class GroundsForAppealPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/grounds_for_appeal'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.grounds_for_appeal.edit.page_title')
    element :file_requirements, 'span', text:I18n.t("shared.file_upload.header")
    element :file_information, 'p', text: "You can’t upload executable (.exe), zip or other archive files due to virus risks."
    element :textarea, '.govuk-textarea'
    section :error_summary, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
      element :virus_error_heading, '#error-summary-title', text: I18n.t('errors.messages.virus_detected')
    end
  end

  def valid_submission
    content.textarea.set 'Grounds for appeal text'
    continue_or_save_continue
  end

  def file_upload_requirements
    content.file_requirements.click
  end
end
