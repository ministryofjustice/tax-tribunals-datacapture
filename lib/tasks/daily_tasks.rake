task :daily_tasks do
  puts "#{Time.now} I'm in ur Rakefile, running ur daily tasks"

  # TODO: to be enabled once we have save and return
  # Rake::Task['case_reminders:first_email'].invoke
  # Rake::Task['case_reminders:last_email'].invoke
  # Rake::Task['tribunal_case:purge'].invoke
end

namespace :case_reminders do
  task :first_email => :environment do
    CaseReminders.new(rule_set: ReminderRuleSet.first_reminder).run
  end

  task :last_email => :environment do
    CaseReminders.new(rule_set: ReminderRuleSet.last_reminder).run
  end
end

namespace :tribunal_case do
  desc "Expire cases older than ENV['EXPIRE_AFTER'] || 14 days"
  task purge: :environment do
    expire_after = ENV.fetch('EXPIRE_AFTER', 14).to_i
    puts "Purging tribunal_cases older than #{expire_after} days."
    purged = TribunalCase.purge!(expire_after.days.ago)
    puts "Purged #{purged} tribunal cases."
  end
end
