class AppealHomepage < BasePage
  set_url '/'

  section :content, '#content' do
    element :appeal_decision_link, 'a', text: 'Appeal against a tax decision'
  end

  def appeal_decision
    content.appeal_decision_link.click
  end
end
