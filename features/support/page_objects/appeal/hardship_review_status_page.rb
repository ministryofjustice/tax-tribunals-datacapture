class HardshipReviewStatusPage < BasePage
  set_url '/en/steps/hardship/hardship_review_status'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.hardship_review_status.question')
  end
end
