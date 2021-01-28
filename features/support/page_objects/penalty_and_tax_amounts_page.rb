class PenaltyAndTaxAmountsPage < BasePage
  set_url '/steps/appeal/penalty_and_tax_amounts'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What are the tax and penalty or surcharge amounts under dispute?'
    element :amount_under_dispute_input, '#steps-appeal-penalty-and-tax-amounts-form-tax-amount-field'
    element :penalty_or_surchange_input, '#steps-appeal-penalty-and-tax-amounts-form-penalty-amount-field'
  end

  def valid_submission
    content.amount_under_dispute_input.set '100'
    content.penalty_or_surchange_input.set '100'
    continue
  end
end
