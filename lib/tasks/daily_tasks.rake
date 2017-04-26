task :daily_tasks do
  puts "#{Time.now} Starting daily tasks"

  Rake::Task['case_reminders:first_email'].invoke
  Rake::Task['case_reminders:last_email'].invoke
    Rake::Task['users:purge'].invoke
  end

  puts "#{Time.now} tribunal_case:purge"
  Rake::Task['tribunal_case:purge'].invoke

  puts "#{Time.now} Finished daily tasks"
end

namespace :case_reminders do
  task :first_email => :environment do
    rule_set = ReminderRuleSet.first_reminder

    puts "#{Time.now} case_reminders:first_email - Count: #{rule_set.count}"
    CaseReminders.new(rule_set: rule_set).run
  end

  task :last_email => :environment do
    rule_set = ReminderRuleSet.last_reminder

    puts "#{Time.now} case_reminders:last_email  - Count: #{rule_set.count}"
    CaseReminders.new(rule_set: rule_set).run
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

namespace :users do
  desc "Delete users who have not logged in for 30 days"
  task purge: :environment do
    puts "Deleting users who have not logged in for 30 or more days."
    purged = TribunalCase.purge!(expire_after.days.ago)
    # `#last_sign_in_at` does not get set until they sign in the first time.
    deleted = User.where(["last_sign_in_at <= :time_ago OR (updated_at <= :time_ago AND last_sign_in_at IS NULL)", time_ago: 30.seconds.ago]).destroy_all
    puts "Deleted #{deleted.size} users."
  end
end
