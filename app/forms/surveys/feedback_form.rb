module Surveys
  class FeedbackForm < BaseForm
    attribute :comment, String
    attribute :email, NormalisedEmail
    attribute :name, String
    attribute :assistance_type, String

    validates_presence_of :name
    validates :email, email: true, allow_blank: false
    validates_presence_of :assistance_type
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
