class ReminderRuleSet
  attr_accessor :created_days_ago,
                :status_in,
                :status_transition_to,
                :email_template_id

  def initialize(created_days_ago:, status_in:, status_transition_to:, email_template_id:)
    @created_days_ago = created_days_ago
    @status_in = status_in
    @status_transition_to = status_transition_to
    @email_template_id = email_template_id
  end

  def self.first_reminder
    new(
      created_days_ago: 8,
      status_in: [nil],
      status_transition_to: CaseStatus::FIRST_REMINDER_SENT,
      email_template_id: ENV.fetch('NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID')
    )
  end

  def self.last_reminder
    new(
      created_days_ago: 10,
      status_in: [CaseStatus::FIRST_REMINDER_SENT],
      status_transition_to: CaseStatus::LAST_REMINDER_SENT,
      email_template_id: ENV.fetch('NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID')
    )
  end

  def find_each(&block)
    TribunalCase.
      with_owner.
      where(case_status: status_in).
      where('created_at <= ?', created_days_ago.days.ago).
      find_each(&block)
  end
end
