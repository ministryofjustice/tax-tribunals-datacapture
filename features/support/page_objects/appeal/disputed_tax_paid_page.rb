class DisputedTaxPaidPage < BasePage
  set_url '/steps/hardship/disputed_tax_paid'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Have you paid the amount of tax under dispute?'
  end
end
