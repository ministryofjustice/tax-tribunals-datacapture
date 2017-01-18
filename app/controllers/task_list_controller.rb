class TaskListController < ApplicationController
  def index
    @presenter = TaskListPresenter.new(current_tribunal_case)
  end
end
