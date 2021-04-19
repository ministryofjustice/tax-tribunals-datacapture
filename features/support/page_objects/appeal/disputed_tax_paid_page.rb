class DisputedTaxPaidPage < BasePage
  set_url '/en/steps/hardship/disputed_tax_paid'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.hardship.disputed_tax_paid.edit.heading')
  end
end
