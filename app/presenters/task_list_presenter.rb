class TaskListPresenter
  TaskListRow = Struct.new(:title, :minutes_to_complete, :value, :start_path)

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper

  def initialize(tribunal_case)
    @tribunal_case = tribunal_case
  end

  attr_reader :tribunal_case

  def rows
    [
      cost_determination_row
    ]
  end

  private

  def cost_determination_row
    if tribunal_case&.lodgement_fee?
      value = number_to_currency(tribunal_case.lodgement_fee.to_gbp)
      TaskListRow.new(:determine_cost, 5, value, steps_cost_start_path)
    else
      TaskListRow.new(:determine_cost, 5, nil, steps_cost_start_path)
    end
  end
end
