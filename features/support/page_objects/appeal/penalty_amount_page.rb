class PenaltyAmountPage < BasePage
  set_url '/steps/appeal/penalty_amount'

  section :content, '#main-content' do
    element :header, 'h1', text: 'How much is the penalty or surcharge you are disputing?'
    element :one_hundred_or_less_option, 'label', text: '£100 or less'
  end

  def submit_100_or_less
    content.one_hundred_or_less_option.click
    continue_or_save_continue
  end
end
