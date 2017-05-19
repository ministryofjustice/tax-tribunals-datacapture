class ZendeskSender
  attr_accessor :form_object

  # This needs to match the value in the `Service` ticket field.
  SERVICE_NAME = 'tax_tribunal'.freeze

  # The following `custom_fields` are created in the Zendesk admin panel,
  # `Manage` section, `Ticket Fields` sub-section. Please note all created
  # fields will show in other service tickets too, so use wisely.
  #
  SERVICE_TICKET_FIELD_ID  = '23757677'.freeze
  BROWSER_TICKET_FIELD_ID  = '23791776'.freeze
  REFERRER_TICKET_FIELD_ID = '26047167'.freeze
  RATING_TICKET_FIELD_ID   = '114094159771'.freeze


  def initialize(form_object)
    @form_object = form_object
  end

  def send!
    ZendeskAPI::Ticket.create!(
      ZENDESK_CLIENT,
      subject: form_object.subject,
      comment: { body: form_object.comment },
      custom_fields: [
        { id: SERVICE_TICKET_FIELD_ID,  value: SERVICE_NAME },
        { id: BROWSER_TICKET_FIELD_ID,  value: form_object.user_agent },
        { id: REFERRER_TICKET_FIELD_ID, value: form_object.referrer },
        { id: RATING_TICKET_FIELD_ID,   value: form_object.rating }
      ]
    )
  end
end
