class DecisionTree
  include ApplicationHelper

  def initialize(object:, step:, next_step: nil)
    @object    = object
    @step      = step
    @next_step = next_step
  end

  def destination
    return @next_step if @next_step

    case step.to_sym
    when :did_challenge_hmrc
      after_did_challenge_hmrc_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def after_did_challenge_hmrc_step
    a = ANSWERS.fetch(:did_challenge_hmrc)

    case answer
    when a.fetch(:yes)
      endpoint "appeal_cost"
    when a.fetch(:no)
      endpoint "must_challenge_hmrc"
    end
  end

  #----------------------

  def endpoint(str)
    Rails.application.routes.url_helpers.decision_path str
  end

  def step
    @step.keys.first
  end

  def answer
    @step.values.first
  end
end
