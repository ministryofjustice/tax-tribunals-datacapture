task :daily_tasks do
  puts "#{Time.now} Starting daily tasks"

  # TODO: to be enabled once we have save and return
  # Rake::Task['case_reminders:first_email'].invoke
  # Rake::Task['case_reminders:last_email'].invoke

  puts "#{Time.now} tribunal_case:purge"
  Rake::Task['tribunal_case:purge'].invoke

  puts "#{Time.now} Finished daily tasks"
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
    expire_after = Rails.configuration.x.cases.expire_in_days
    puts "Purging tribunal_cases older than #{expire_after} days."
    purged = TribunalCase.purge!(expire_after.days.ago)
    puts "Purged #{purged} tribunal cases."
  end
end
