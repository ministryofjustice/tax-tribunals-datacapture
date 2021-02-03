class TaxpayerTypePage < BasePage
  set_url '/steps/details/taxpayer_type'

  section :content, '#main-content' do
    element :closure_header, 'h1', text: 'Who is making the application?'
    element :appeal_header, 'h1', text: 'Who is making the appeal?'
    element :individual, 'label', text: 'Individual'
    element :company, 'label', text: 'Company'
    element :other, 'label', text: 'Other type of organisation'
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
