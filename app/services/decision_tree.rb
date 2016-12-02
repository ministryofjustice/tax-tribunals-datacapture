class DecisionTree
  include ApplicationHelper

  def initialize(object:, step:, next_step: nil)
    @object    = object
    @step      = step
    @next_step = next_step
  end

  private

  def step
    @step.keys.first
  end

  def answer
    @step.values.first.to_sym
  end

  def show(step)
    { controller: step, action: :show }
  end

  def edit(step)
    { controller: step, action: :edit }
  end

  def home
    { controller: '/home', action: :index }
  end
end
