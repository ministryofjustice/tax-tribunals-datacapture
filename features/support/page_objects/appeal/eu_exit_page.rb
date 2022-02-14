class EuExitPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + "/steps/#{@pathway}/eu_exit"

  def initialize(pathway)
    @pathway = pathway
  end

  section :content, '#main-content' do
    element :header, 'h1'
  end

end
