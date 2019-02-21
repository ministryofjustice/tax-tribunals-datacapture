class AdditionalInfoPage < BasePage
  set_url '/steps/closure/additional_info'

  section :content, '#content' do
    element :header, 'h1', text: 'Why should the enquiry close? (optional)'
    element :reason_input, '#steps_closure_additional_info_form_closure_additional_info'
  end

  def provide_reason
    content.reason_input.set 'My very sensible reasons.'
  end
end
