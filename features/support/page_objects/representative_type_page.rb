class RepresentativeTypePage < BasePage
  set_url '/en/steps/details/representative_type'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('helpers.fieldset.steps_details_representative_type_form.representative_type_html')
    element :individual, 'label', text: I18n.t('steps.details.representative_type.edit.individual')
  end

  def submit_individual
    content.individual.click
    continue_or_save_continue
  end
end
