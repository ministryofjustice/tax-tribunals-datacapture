class ChallengeDecisionStatusPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/challenge/decision_status'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.challenge.decision_status.edit.heading')
    element :review_conclusion_letter, 'label', text: I18n.t('dictionary.CHALLENGE_STATUS.received')
  end

  def submit_review_conclusion_letter
    content.review_conclusion_letter.click
    continue
  end
end
