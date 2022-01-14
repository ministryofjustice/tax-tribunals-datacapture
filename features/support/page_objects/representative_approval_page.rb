class RepresentativeApprovalPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/representative_approval'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.representative_approval.edit.heading.as_taxpayer')
    element :how_to_authorise_dropdown, 'span', text: I18n.t('steps.details.representative_approval.edit.details_heading.as_taxpayer')
    element :authorise_dropdown_content, 'p', text: "If your appeal is for a company, you will need a company director to sign the form."
    element :file_upload_requirements_dropdown, 'span', text: I18n.t('shared.file_upload.header')
    element :file_requirements_dropdown_content, 'p', text: "You can’t upload executable (.exe), zip or other archive files due to virus risks."
  end

  def authorise_representative_dropdown
    content.how_to_authorise_dropdown.click
  end

  def file_upload_dropdown
    content.file_upload_requirements_dropdown.click
  end

end

