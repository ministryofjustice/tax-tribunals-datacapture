class EuExitPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + "/steps/#{@pathway}/eu_exit"

  def initialize(pathway)
    @pathway = pathway
  end

  def self.translate_with_appeal_or_application(path)
    appeal_or_application = @pathway == 'closure' ? 'appeal' : 'application'
    I18n.t(path,
      appeal_or_application: I18n.t("generic.appeal_or_application.#{appeal_or_application}")
    )
  end

  section :content, '#main-content' do
    element :header, 'h1', text: EuExitPage.translate_with_appeal_or_application(
          'steps.shared.eu_exit.edit.heading')
  end

end
