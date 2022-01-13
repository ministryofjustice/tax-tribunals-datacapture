class ChallengeDecisionStatusPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/challenge/decision_status'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.challenge.decision_status.edit.heading')
    element :review_conclusion_letter, 'label', text: I18n.t('dictionary.CHALLENGE_STATUS.received')
    element :less_than_fourty_five, 'label', text: I18n.t('dictionary.CHALLENGE_STATUS.pending')
    element :more_than_fourty_five, 'label', text: I18n.t('dictionary.CHALLENGE_STATUS.overdue')
    element :direct, 'label', text: I18n.t('dictionary.CHALLENGE_STATUS.appealing_directly')
    element :review, 'label', text: I18n.t('dictionary.CHALLENGE_STATUS.not_required')
    element :appeal_late_rejection, 'label', text: I18n.t('dictionary.CHALLENGE_STATUS.appeal_late_rejection')
    section :error,'.govuk-error-summary' do
    element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
  end
  end

  def direct
    content.direct.click
    continue_or_save_continue
  end

  def review
    content.review.click
    continue_or_save_continue
  end

  def more_than_fourtyfive
    content.more_than_fourty_five.click
    continue_or_save_continue
  end

def submit_review_conclusion_letter
  content.review_conclusion_letter.click
  continue_or_save_continue
end

def submit_less_than_fourty_five_days
  content.less_than_fourty_five.click
  continue_or_save_continue
end

def late_appeal
  content.appeal_late_rejection.click
  continue_or_save_continue
end

def submit_review_letter
    content.review_conclusion_letter.click
    continue_or_save_continue
  end
end
