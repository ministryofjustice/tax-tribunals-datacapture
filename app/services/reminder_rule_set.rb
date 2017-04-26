class ReminderRuleSet
  attr_accessor :created_days_ago,
                :status,
                :status_transition_to,
                :email_template_id

  delegate :find_each, :count, to: :rule_query

  def initialize(created_days_ago:, status:, status_transition_to:, email_template_id:)
    @created_days_ago = created_days_ago
    @status = status
    @status_transition_to = status_transition_to
    @email_template_id = email_template_id
  end

  def self.first_reminder
    new(
      created_days_ago: 8,
      status: nil,
      status_transition_to: CaseStatus::FIRST_REMINDER_SENT,
      email_template_id: ENV.fetch('NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID')
    )
  end

  def self.last_reminder
    new(
      created_days_ago: 10,
      status: CaseStatus::FIRST_REMINDER_SENT,
      status_transition_to: CaseStatus::LAST_REMINDER_SENT,
      email_template_id: ENV.fetch('NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID')
    )
  end

  private

  def rule_query
    TribunalCase.
      with_owner.
      where(case_status: status).
      where('created_at <= ?', created_days_ago.days.ago)
  end
end
