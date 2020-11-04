class ChallengeDecisionPage < BasePage
  set_url '/steps/challenge/decision'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Did you appeal the original decision to HMRC? '
    element :save_and_come_back, 'a', text: 'Save and come back later'
  end

  def save_and_come_back
    content.save_and_come_back.click
  end
end
