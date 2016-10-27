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
    when :what_is_appeal_about_challenged
      after_what_is_appeal_about_challenged_step
    when :what_is_appeal_about_unchallenged
      after_what_is_appeal_about_unchallenged_step
    else
      raise "Invalid step '#{step}'"
    end
  end

  private

  def after_did_challenge_hmrc_step
    a = ANSWERS.fetch(:did_challenge_hmrc)

    case answer
    when a.fetch(:yes)
      { controller: :what_is_appeal_about_challenged, action: :edit }
    when a.fetch(:no)
      { controller: :what_is_appeal_about_unchallenged, action: :edit }
    end
  end

  def after_what_is_appeal_about_challenged_step
    { controller: :determine_cost, action: :show }
  end

  def after_what_is_appeal_about_unchallenged_step
    { controller: :determine_cost, action: :show }
  end

  def step
    @step.keys.first
  end

  def answer
    @step.values.first
  end
end
