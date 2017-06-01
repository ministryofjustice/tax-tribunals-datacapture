class TaxTribs::CaseReminders
  attr_reader :rule_set

  def initialize(rule_set:)
    @rule_set = rule_set
  end

  def run
    rule_set.find_each do |tribunal_case|
      send_reminder(tribunal_case)
    end
  end

  private

  def send_reminder(tribunal_case)
    NotifyMailer.incomplete_case_reminder(tribunal_case, rule_set.email_template_id).deliver_later

    tribunal_case.update(
      case_status: rule_set.status_transition_to
    )
  end
end
