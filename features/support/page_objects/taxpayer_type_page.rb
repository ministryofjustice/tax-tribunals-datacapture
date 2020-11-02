class TaxpayerTypePage < BasePage
  set_url '/steps/details/taxpayer_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Who is making the application?'
    element :individual, 'label', text: 'Individual'
    element :company, 'label', text: 'Company'
    element :other, 'label', text: 'Other type of organisation'
  end

  def submit_individual
    content.individual.click
    continue
  end

  def submit_company
    content.company.click
    continue
  end

  def submit_other
    content.other.click
    continue
  end
end
