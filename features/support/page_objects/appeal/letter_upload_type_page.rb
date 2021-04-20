class LetterUploadTypePage < BasePage
  set_url '/en/steps/details/letter_upload_type'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('shared.letter_upload.heading.review_conclusion_letter')
    element :one_doc_option, 'label', text: I18n.t('helpers.label.steps_details_letter_upload_type_form.letter_upload_type_options.single')
  end

  def submit_one_document_option
    content.one_doc_option.click
    continue_or_save_continue
  end
end
