class CheckAnswersPage < BasePage
  set_url '/steps/closure/check_answers'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Check your answers'
    element :application_type_heading, 'h2', text: 'Application type'
    element :taxpayer_details_heading, 'h2', text: 'Taxpayer details'
    element :enquiry_details_heading, 'h2', text: 'Enquiry details'
  end
end
