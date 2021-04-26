class HomeController < ApplicationController
  def index
    reset_tribunal_case_session
    @link_sections = link_sections
  end

  def contact
  end

  def cookies
    @form_object = Cookie::SettingForm.new(
      request: request
    )
  end

  def terms
  end

  def privacy
  end

  def accessibility
  end

  def guidance
  end

  def update
    Cookie::SettingForm.new(
      cookie_setting: cookie_setting,
      response: response
    ).save
    flash[:cookie_notification] = cookie_notification
    redirect_to request.referer
  end

  private

  def cookie_setting
    params[:cookie_setting_form]
      .permit(:cookie_setting)
      .to_h
      .fetch(:cookie_setting)
  end

  def cookie_notification
    if params[:cookie_banner].present?
      cookie_setting
    else
      true
    end
  end

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  # Use '0' minutes to hide the time to complete paragraph
  def link_sections
    [
      [:appeal, 30, appeal_path],
      [:close, 15, closure_path],
      [:home_login, 0, helpers.login_or_portfolio_path],
      [:guidance, 0, guidance_path]
    ]
  end
end
