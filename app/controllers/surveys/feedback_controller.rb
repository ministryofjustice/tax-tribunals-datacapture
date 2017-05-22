module Surveys
  class FeedbackController < SurveyBaseController
    protected

    def form_object_class
      Surveys::FeedbackForm
    end
  end
end
