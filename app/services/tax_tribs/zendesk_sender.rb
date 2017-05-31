class TaxTribs::ZendeskSender
  attr_accessor :form_object

  # This needs to match the value in the `Service` ticket field.
  SERVICE_NAME = 'datacapture_app'.freeze

  # The following `custom_fields` are created in the Zendesk admin panel,
  # `Manage` section, `Ticket Fields` sub-section.
  SERVICE_FIELD_ID    = '79094767'.freeze
  USER_AGENT_FIELD_ID = '79531628'.freeze
  REFERRER_FIELD_ID   = '79094927'.freeze
  RATING_FIELD_ID     = '79096207'.freeze


  def initialize(form_object)
    @form_object = form_object
  end

  def send!
    ZendeskAPI::Ticket.create!(
      ZENDESK_CLIENT,
      requester: requester_details,
      subject: form_object.subject,
      comment: { body: form_object.comment },
      custom_fields: [
        { id: SERVICE_FIELD_ID,    value: SERVICE_NAME },
        { id: USER_AGENT_FIELD_ID, value: form_object.user_agent },
        { id: REFERRER_FIELD_ID,   value: form_object.referrer },
        { id: RATING_FIELD_ID,     value: form_object.rating }
      ]
    )
  end

  private

  def requester_details
    {name: requester_name, email: requester_email} if requester_email.present?
  end

  def requester_email
    form_object.email
  end

  # We are not asking for a name, so we default to the first part of the user email
  def requester_name
    requester_email.split('@').first
  end
end
