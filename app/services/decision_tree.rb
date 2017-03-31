class DecisionTree
  include ApplicationHelper

  attr_reader :tribunal_case, :step_params, :as, :next_step

  def initialize(tribunal_case:, step_params: {}, as: nil, next_step: nil)
    @tribunal_case = tribunal_case
    @step_params   = step_params
    @as            = as
    @next_step     = next_step
  end

  private

  def step_name
    as || step_params.keys.first
  end

  def answer
    step_params.values.first.to_sym
  end

  def show(step_controller)
    { controller: step_controller, action: :show }
  end

  def edit(step_controller)
    { controller: step_controller, action: :edit }
  end

  def start_path
    { controller: '/home', action: :start }
  end

  def dispute_or_penalties_decision
    if tribunal_case.case_type.ask_dispute_type?
      edit('/steps/appeal/dispute_type')
    elsif tribunal_case.case_type.ask_penalty?
      edit('/steps/appeal/penalty_amount')
    else
      edit('/steps/lateness/in_time')
    end
  end
end
