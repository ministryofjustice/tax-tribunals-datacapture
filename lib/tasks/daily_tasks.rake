task :daily_tasks do
  puts "#{Time.now} Starting daily tasks"

  Rake::Task['case_reminders:first_email'].invoke
  Rake::Task['case_reminders:last_email'].invoke

  puts "#{Time.now} tribunal_case:purge"
  Rake::Task['tribunal_case:purge'].invoke

  puts "#{Time.now} users:purge"
  Rake::Task['users:purge'].invoke

  puts "#{Time.now} reports:cases_by_date_csv"
  Rake::Task['reports:cases_by_date_csv'].invoke

  puts "Backup noas"
  Rake::Task['backup_noas'].invoke

  puts "#{Time.now} Finished daily tasks"
end

namespace :case_reminders do
  task :first_email => :environment do
    rule_set = TaxTribs::ReminderRuleSet.first_reminder

    puts "#{Time.now} case_reminders:first_email - Count: #{rule_set.count}"
    TaxTribs::CaseReminders.new(rule_set: rule_set).run
  end

  task :last_email => :environment do
    rule_set = TaxTribs::ReminderRuleSet.last_reminder

    puts "#{Time.now} case_reminders:last_email  - Count: #{rule_set.count}"
    TaxTribs::CaseReminders.new(rule_set: rule_set).run
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
  desc "Expire users who have not logged in for 30 days"
  task purge: :environment do
    expire_after = Rails.configuration.x.users.expire_in_days
    puts "Purging users who have not logged in for #{expire_after} days."
    purged = User.purge!(expire_after.days.ago)
    puts "Purged #{purged.size} users."
  end
end

namespace :reports do
  desc "Email CSV of cases created/submitted by date"
  task cases_by_date_csv: :environment do
    if ENV['STATISTICS_REPORT_EMAIL_ADDRESS']
      csv = TaxTribs::StatisticsReport.cases_by_date_csv
      NotifyMailer.statistics_report("Cases by Date", csv).deliver!
    end
  end
end
