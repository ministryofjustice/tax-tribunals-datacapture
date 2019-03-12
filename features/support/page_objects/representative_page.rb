class RepresentativePage < BasePage
  set_url '/steps/details/has_representative'

  section :content, '#content' do
    element :header, 'h1', text: 'Do you have someone to represent you?'
  end
end