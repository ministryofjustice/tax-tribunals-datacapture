class RepresentativePage < BasePage
  set_url '/steps/details/has_representative'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Do you have someone to represent you?'
    element :representative, '.govuk-hint'
  end
end
