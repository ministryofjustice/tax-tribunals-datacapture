module Surveys
  class FeedbackForm < BaseForm
    attribute :comment, String
    attribute :email, NormalisedEmail
    attribute :name, String
    attribute :assistance_level, String

    validates_presence_of :name
    validates :email, presence: true, 'valid_email_2/email': true
    validates_presence_of :assistance_level
    validates_presence_of :comment

    # TODO: once we have at least 2 of these feedback forms, we can extract
    # the duplicated code to a superclass as all of them will have at least
    # #subject, #comment and #persist! methods along with some common
    # attributes like `referrer` and `user_agent`
    #
    def subject
      'Report a problem'.freeze
    end

    private

    def persist!
      NotifyMailer.report_problem(self).deliver_now
    end
  end
end
