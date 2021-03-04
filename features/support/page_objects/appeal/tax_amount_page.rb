class TaxAmountPage < BasePage
  set_url '/en/steps/appeal/tax_amount'

  section :content, '#main-content' do
    element :header, 'h1', text: 'How much tax is under dispute?'
    element :textbox, "input[name='steps_appeal_tax_amount_form[tax_amount]']"
    section :error_summary, '.govuk-error-summary__body' do
      element :enter_tax_amount_error, 'a', text: "Enter the tax amount (or 'unknown' if you don't have it)"
    end
  end

  def valid_submission
    content.textbox.set '100'
    continue_or_save_continue
  end
end
