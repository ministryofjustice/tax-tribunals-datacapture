class UserTypePage < BasePage
  set_url '/steps/details/user_type'

  section :content, '#main-content' do
    element :closure_header, 'h1', text: 'Are you the taxpayer making the application?'
    element :appeal_header, 'h1', text: 'Are you the taxpayer making the appeal?'
  end
end
