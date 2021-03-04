class ChallengeDecisionStatusPage < BasePage
  set_url '/en/steps/challenge/decision_status'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What response did you receive?'
    element :review_conclusion_letter, 'label', text: 'I have a review conclusion letter'
  end

  def submit_review_conclusion_letter
    content.review_conclusion_letter.click
    continue
  end
end
