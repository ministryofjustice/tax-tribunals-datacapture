module Surveys
  class FeedbackForm < BaseForm
    attribute :rating, Integer
    attribute :comment, String
    attribute :email, NormalisedEmail
    attribute :referrer, String
    attribute :user_agent, String

    validates :email, email: true, allow_blank: true
    validates_presence_of :comment

    # TODO: once we have at least 2 of these feedback forms, we can extract
    # the duplicated code to a superclass as all of them will have at least
    # #subject, #comment and #persist! methods along with some common
    # attributes like `referrer` and `user_agent`
    #
    def subject
      'Feedback'.freeze
    end

    private

    def persist!
      TaxTribs::ZendeskSender.new(self).send!
    end
  end
end
