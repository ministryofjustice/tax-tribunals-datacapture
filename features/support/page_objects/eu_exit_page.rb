class EuExitPage < BasePage
  set_url '/steps/details/eu_exit'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Is your appeal as a result of the exit by the United Kingdom from the European Union? (optional)'
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
