module SaveAndReturn
  class SaveForm < BaseForm
    attribute :save_for_later, Boolean

    # validates_presence_of :name
    # validates :email, email: true, allow_blank: false
    # validates_presence_of :assistance_level
    # validates_presence_of :comment

    private

    def persist!
      # NotifyMailer.report_problem(self).deliver_now
    end
  end
end
