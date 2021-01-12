class SupportDocumentsPage < BasePage
  set_url '/steps/closure/support_documents'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Add documents to support your application (optional)'
    element :trouble_checkbox, 'label', text: 'I am having trouble uploading my documents'
    element :trouble_textarea, '#steps-closure-support-documents-form-having-problems-uploading-explanation-field'
  end
end
