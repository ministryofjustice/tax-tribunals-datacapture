class SupportDocumentsPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/closure/support_documents'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.closure.support_documents.edit.heading')
    element :trouble_checkbox, 'label', text: I18n.t('steps.closure.support_documents.edit.having_problems_uploading')
    element :trouble_textarea, '#steps-closure-support-documents-form-having-problems-uploading-explanation-field'
  end
end
