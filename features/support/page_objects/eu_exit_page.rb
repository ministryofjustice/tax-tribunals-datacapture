class EuExitPage < BasePage
  set_url '/steps/details/eu_exit'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Is your appeal as a result of the exit by the United Kingdom from the European Union? (optional)'
  end
end
