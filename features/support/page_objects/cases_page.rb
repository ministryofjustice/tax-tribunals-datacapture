class CasesPage < BasePage
  set_url '/users/cases'

  section :content, '#content' do
    element :header, 'h1', text: 'Your saved cases'
    element :resume_button, '.button', text: 'Resume'
  end

  def resume
    content.resume_button.click
  end
end
