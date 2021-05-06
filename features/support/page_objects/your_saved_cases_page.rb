class YourSavedCasesPage < BasePage
  set_url '/en/users/cases'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('users.cases.index.heading')
    element :resume_button, 'a', text: I18n.t('users.cases.case_row.resume')
  end

  def resume
    content.resume_button.click
  end
end
