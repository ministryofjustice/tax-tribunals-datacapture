module Feedback
  class FeedbackForm < BaseForm
    attribute :rating, Integer
    attribute :comment, String
    attribute :referrer, String
    attribute :user_agent, String

    def self.rating_choices
      (1..5)
    end

    validates_inclusion_of :rating, in: rating_choices
    validates_presence_of  :comment

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
      ZendeskSender.new(self).send!
    end
  end
end
