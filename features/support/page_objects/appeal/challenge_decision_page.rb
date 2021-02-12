class ChallengeDecisionPage < BasePage
  set_url '/steps/challenge/decision'

  section :content, '#main-content' do
    element :appeal_header, 'h1', text: 'Did you appeal the original decision to HMRC?'
    element :review_header, 'h1', text: 'Did you ask for a review of the original decision?'
    element :help_with_challenging_a_decision, 'span', text: /Help with challenging a tax decision/
  end
end
