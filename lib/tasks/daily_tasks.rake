task :daily_tasks do
  puts "I'm in ur Rakefile, running ur daily tasks"

  # TODO: to be enabled once we have save and return
  # Rake::Task['case_reminders:first_email'].invoke
  # Rake::Task['case_reminders:last_email'].invoke
end

namespace :case_reminders do
  task :first_email => :environment do
    CaseReminders.new(rule_set: ReminderRuleSet.first_reminder).run
  end

  task :last_email => :environment do
    CaseReminders.new(rule_set: ReminderRuleSet.last_reminder).run
  end
end
