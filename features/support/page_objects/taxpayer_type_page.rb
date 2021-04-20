class TaxpayerTypePage < BasePage
  set_url '/en/steps/details/taxpayer_type'

  section :content, '#main-content' do
    element :closure_header, 'h1', text: I18n.t('steps.details.taxpayer_type.edit.heading.application_test')
    element :appeal_header, 'h1', text: I18n.t('steps.details.taxpayer_type.edit.heading.appeal_test')
    element :individual, 'label', text: I18n.t('steps.details.representative_type.edit.individual')
    element :company, 'label', text: I18n.t('steps.details.representative_type.edit.company')
    element :other, 'label', text: I18n.t('steps.details.representative_type.edit.other')
  end

  def submit_individual
    content.individual.click
    continue_or_save_continue
  end

  def submit_company
    content.company.click
    continue_or_save_continue
  end

  def submit_other
    content.other.click
    continue_or_save_continue
  end
end
