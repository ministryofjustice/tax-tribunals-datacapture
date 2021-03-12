class RepresentativeTypePage < BasePage
  set_url '/en/steps/details/representative_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Is your representative an individual, company or other type of organisation?'
    element :individual, 'label', text: 'Individual'
  end

  def submit_individual
    content.individual.click
    continue_or_save_continue
  end
end
