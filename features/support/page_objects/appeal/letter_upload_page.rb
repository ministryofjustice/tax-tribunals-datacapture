class LetterUploadPage < BasePage
  set_url '/en/steps/details/letter_upload'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('shared.letter_upload.heading.review_conclusion_letter')
    element :lead_text, 'p', text: I18n.t('shared.letter_upload.heading.lead_text')
  end
end
