class LetterUploadTypePage < BasePage
  set_url '/en/steps/details/letter_upload_type'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('shared.letter_upload.heading.review_conclusion_letter')
    element :one_doc_option, 'label', text: I18n.t('helpers.label.steps_details_letter_upload_type_form.letter_upload_type_options.single_test')
    element :multiple_pages, 'label', text: I18n.t('helpers.label.steps_details_letter_upload_type_form.letter_upload_type_options.multiple_test')
    element :no_letter, 'label', text: I18n.t('helpers.label.steps_details_letter_upload_type_form.letter_upload_type_options.no_letter_test')
    element :no_letter_text, 'p', text: I18n.t('steps.details.letter_upload_type.edit.no_letter_info_html')
  end

  def submit_one_document_option
    content.one_doc_option.click
    continue_or_save_continue
  end

  def submit_multiple_option
    content.multiple_pages.click
    continue_or_save_continue
  end

  def no_letter
    content.no_letter.click
  end

end
