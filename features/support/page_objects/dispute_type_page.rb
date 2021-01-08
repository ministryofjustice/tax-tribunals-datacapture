class DisputeTypePage < BasePage
  set_url '/steps/appeal/dispute_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What is your dispute about?'
    element :penalty_or_surcharge_option, 'label', text: /Penalty or surcharge/
  end

  def submit_penalty_or_surcharge
    content.penalty_or_surcharge_option.click
    continue
  end
end
