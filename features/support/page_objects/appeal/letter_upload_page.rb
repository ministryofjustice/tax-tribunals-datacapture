class LetterUploadPage < BasePage
  set_url '/en/steps/details/letter_upload'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Upload the review conclusion letter'
    element :lead_text, 'p', text: "We accept a good quality and legible scan or photograph. Your appeal may be returned if we can't read the letter, and you risk missing the deadline."
  end
end
