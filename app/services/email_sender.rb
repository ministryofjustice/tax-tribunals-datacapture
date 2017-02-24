# Send an email via gov.uk notify, using a template that has been pre-defined on that service
# e.g.
#
#   sender = EmailSender.new(
#     first_name: "Bob",
#     ref_number: "SOMEREF1234",
#     email_address: "david.salgado@digital.justice.gov.uk"
#   )
#   sender.send_test_email
#
# The return value from #send_test_email is something like;
#
#   #<Notifications::Client::ResponseNotification:0x007fbb2266ac80 @id="62f553a9-66a6-4319-8f41-7043c9840b31">
#
# NB: In trial mode, you can only send email addresses that have been whitelisted on
#     https://www.notifications.service.gov.uk
#
class EmailSender
  # first_name and ref_number are variables in the template defined on gov.uk notify
  attr_reader :email_address, :first_name, :ref_number

  def initialize(params)
    @notify_client = Notifications::Client.new(ENV.fetch('GOV_UK_NOTIFY_API_KEY'))
    @first_name = params.fetch(:first_name)
    @ref_number = params.fetch(:ref_number)
    @email_address = params.fetch(:email_address)
  end

  def send_test_email
    @notify_client.send_email(
      to: email_address,
      template: ENV.fetch('EMAIL_TEMPLATE_TEST'),
      personalisation: {
        first_name: first_name,
        ref_number: ref_number
      }
    )
  end
end
