class LetterUploadPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/letter_upload'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('shared.letter_upload.heading.review_conclusion_letter')
    element :lead_text, 'p', text: I18n.t('shared.letter_upload.heading.lead_text')
    element :trouble_upload_checkbox, 'label', text: I18n.t('helpers.label.steps_details_letter_upload_form.having_problems_uploading_options.having_problems_uploading')
    element :textarea, '.govuk-textarea'
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def select_trouble_uploading
    content.trouble_upload_checkbox.click
  end

  def valid_text_reason
    content.textarea.set 'Reason for not uploading a letter'
    continue_or_save_continue
  end
end

