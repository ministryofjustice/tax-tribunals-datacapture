class HardshipReviewRequestedPage < BasePage
  set_url '/en/steps/hardship/hardship_review_requested'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Did you ask HMRC if you could appeal to the tribunal without paying the tax first?'
  end
end
