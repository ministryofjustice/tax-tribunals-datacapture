class RepresentativeProfessionalPage < BasePage
  set_url '/en/steps/details/representative_professional_status'

  section :content, '#main-content' do
    element :representatives_header, 'h1', text: 'Who are you?'
    element :individuals_header, 'h1', text: 'Who is representing you?'
    element :practising_solicitor_option, 'label', text: 'Practising solicitor or barrister in England, Wales or Northern Ireland'
  end

  def submit_practising_solicitor
    content.practising_solicitor_option.click
    continue_or_save_continue
  end
end
