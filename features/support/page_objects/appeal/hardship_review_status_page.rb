class HardshipReviewStatusPage < BasePage
  set_url '/en/steps/hardship/hardship_review_status'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Did HMRC allow you to defer paying because of financial hardship?'
  end
end
