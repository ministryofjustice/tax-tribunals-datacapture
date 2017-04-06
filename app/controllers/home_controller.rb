class HomeController < ApplicationController
  def start
    reset_session
    @link_sections = link_sections
  end

  def index
  end

  def contact
  end

  def terms_and_conditions
  end

  def create_account
  end

  def check_email
  end

  def appeal_saved
  end

  private

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  def link_sections
    [
      [:appeal, 30, steps_appeal_start_path],
      [:close, 15, steps_closure_start_path]
    ]
  end
end
