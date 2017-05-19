class FeedbackController < ApplicationController
  def new
    @form_object = Feedback::FeedbackForm.new(
      referrer: referrer_path
    )
  end

  def create
    @form_object = Feedback::FeedbackForm.new(feedback_params)

    if @form_object.save
      redirect_to thanks_feedback_path
    else
      render :new
    end
  end

  def thanks
  end

  private

  def referrer_path
    URI(request.referrer.to_s).path
  end

  def feedback_params
    permitted_params.merge(user_agent: request.user_agent)
  end

  def permitted_params
    params.require(:feedback_feedback_form).permit(
      :rating, :comment, :referrer
    ).to_h
  end
end
