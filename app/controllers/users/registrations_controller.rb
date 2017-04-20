module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :ensure_tribunal_case

    def create
      super do |user|
        if user.persisted?
          current_tribunal_case.update(user: user)
          send_confirmation_email
        end
      end
    end

    private

    def ensure_tribunal_case
      redirect_to case_not_found_errors_path unless current_tribunal_case
    end

    def send_confirmation_email
      NotifyMailer.new_account_confirmation(current_tribunal_case).deliver_later
    end

    def after_sign_up_path_for(_)
      appeal_saved_path
    end
  end
end
