class TaskListPresenter
  TaskListRow = Struct.new(:title, :minutes_to_complete, :value, :start_path, :can_start?)

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  attr_reader :tribunal_case

  def rows
    [
      cost_determination_row,
      lateness_row
    ]
  end

  private

  def cost_determination_row
    if tribunal_case&.lodgement_fee?
      value = number_to_currency(tribunal_case.lodgement_fee.to_gbp)
      TaskListRow.new(:determine_cost, 5, value, steps_cost_start_path, false)
    else
      TaskListRow.new(:determine_cost, 5, nil, steps_cost_start_path, true)
    end
  end

  def lateness_row
    if tribunal_case&.in_time
      TaskListRow.new(:lateness, 5, tribunal_case.in_time, steps_lateness_start_path, false)
    elsif tribunal_case&.lodgement_fee?
      TaskListRow.new(:lateness, 5, nil, steps_lateness_start_path, true)
    else
      TaskListRow.new(:lateness, 5, nil, steps_lateness_start_path, false)
    end
  end
end
