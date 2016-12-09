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

  def home
    { controller: '/home', action: :index }
  end
end
