class UserTypePage < BasePage
  set_url '/steps/details/user_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Are you the taxpayer making the application?'
    element :yes, 'label', text: 'Yes'
    element :no, 'label', text: 'No'
  end

  def submit_yes
    content.yes.click
    continue
  end

  def submit_no
    content.no.click
    continue
  end
end
