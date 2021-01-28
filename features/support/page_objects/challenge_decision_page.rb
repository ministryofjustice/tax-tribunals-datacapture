class ChallengeDecisionPage < BasePage
  set_url '/steps/challenge/decision'

  section :content, '#main-content' do
    element :appeal_header, 'h1', text: 'Did you appeal the original decision to HMRC?'
    element :review_header, 'h1', text: 'Did you ask for a review of the original decision?'
    element :help_with_challenging_a_decision, 'span', text: /Help with challenging a tax decision/
    element :save_and_come_back, 'a', text: 'Save and come back later'
  end

  def save_and_come_back
    content.save_and_come_back.click
  end
end
