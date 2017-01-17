class HomeController < ApplicationController
  def index
    @link_sections = link_sections
  end

  private

  # [task name, estimated time to complete this task, path to the task]
  def link_sections
    [
      [:appeal, 30, task_list_path],
      [:close, 15, '#'],
      [:pay, 5, ENV.fetch('PAYMENT_EXTERNAL_URL')]
    ]
  end
end
