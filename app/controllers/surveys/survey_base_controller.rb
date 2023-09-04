module Surveys
  class SurveyBaseController < ApplicationController
    def new
      @form_object = form_object_class.new(
        referrer: referrer_path
      )
    end

    def create
      @form_object = form_object_class.new(**survey_params)

      if @form_object.save
        redirect_to action: :thanks
      else
        render :new
      end
    end

    def thanks
    end

    protected

    # :nocov:
    def form_object_class
      raise 'implement in subclasses'
    end
    # :nocov:

    private

    def referrer_path
      URI(request.referrer.to_s).path
    end

    def survey_params
      permitted_params.merge(user_agent: request.user_agent)
    end

    def permitted_params
      params_key = form_object_class.name.underscore.tr('/'.freeze, '_'.freeze)

      params.require(params_key).permit(
        :rating, :comment, :name, :assistance_level, :email, :referrer
      ).to_h
    end
  end
end
