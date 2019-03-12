class GroundsForAppealPage < BasePage
  set_url '/steps/details/grounds_for_appeal'

  section :content, '#content' do
    element :uploaded_document, '.uploaded_document_container', text: 'Previously attached document: grounds_for_appeal.docx'
  end
end