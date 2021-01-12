class HasRepresentativePage < BasePage
  set_url '/steps/details/has_representative'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Do you have someone to represent you?'
    element :representative, 'p', text: 'A representative is anyone you want to receive correspondence or go to a hearing for you. You can authorise a representative at any time during your appeal.'
    element :yes_option, 'label', text: 'Yes'
    element :no_option, 'label', text: 'No'
  end

  def submit_yes
    content.yes_option.click
    continue
  end

  def submit_no
    content.no_option.click
    continue
  end
end
