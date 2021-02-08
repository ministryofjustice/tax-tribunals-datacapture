class YourSavedCasesPage < BasePage
  set_url '/users/cases'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Your saved cases'
    element :resume_button, 'a', text: 'Resume'
  end

  def resume
    content.resume_button.click
  end
end
