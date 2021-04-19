class HardshipReviewRequestedPage < BasePage
  set_url '/en/steps/hardship/hardship_review_requested'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.hardship.hardship_review_requested.edit.heading')
  end
end
