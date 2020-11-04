class RepresentativeProfessionalPage < BasePage
  set_url '/steps/details/representative_professional_status'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Who are you?'
  end
end
