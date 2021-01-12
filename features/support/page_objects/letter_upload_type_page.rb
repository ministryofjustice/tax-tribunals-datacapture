class LetterUploadTypePage < BasePage
  set_url '/steps/details/letter_upload_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Upload the review conclusion letter'
    element :one_doc_option, 'label', text: %r{Upload the letter as one document}
  end

  def submit_one_document_option
    content.one_doc_option.click
    continue
  end
end
