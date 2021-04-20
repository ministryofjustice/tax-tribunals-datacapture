class  HasRepresentativePage < BasePage
  set_url '/en/steps/details/has_representative'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.has_representative.edit.heading')
    element :representative, 'p', text: I18n.t('steps.details.has_representative.edit.lead_text')
  end
end
