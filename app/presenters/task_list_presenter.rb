class TaskListPresenter
  TaskListRow = Struct.new(:title, :minutes_to_complete, :value, :i18n_value, :start_path, :show_start_button?)

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  attr_reader :tribunal_case

  def rows
    [
      cost_determination_row,
      lateness_row,
      details_row
    ]
  end

  private

  def cost_determination_row
    if tribunal_case&.cost_task_completed?
      value = number_to_currency(tribunal_case.lodgement_fee / 100.0)
      TaskListRow.new(:determine_cost, 5, value, nil, steps_appeal_start_path, false)
    else
      TaskListRow.new(:determine_cost, 5, nil, nil, steps_appeal_start_path, true)
    end
  end

  def lateness_row
    if tribunal_case&.lateness_task_completed?
      value = tribunal_case.in_time
      i18n_value = ".task_answers.in_time.#{value}"
      TaskListRow.new(:lateness, 5, value, i18n_value, steps_lateness_start_path, false)
    elsif tribunal_case&.cost_task_completed?
      TaskListRow.new(:lateness, 5, nil, nil, steps_lateness_start_path, true)
    else
      TaskListRow.new(:lateness, 5, nil, nil, steps_lateness_start_path, false)
    end
  end

  def details_row
    if tribunal_case&.cost_task_completed? && tribunal_case&.lateness_task_completed?
      TaskListRow.new(:details, 20, nil, nil, steps_details_start_path, true)
    else
      TaskListRow.new(:details, 20, nil, nil, steps_details_start_path, false)
    end
  end
end
