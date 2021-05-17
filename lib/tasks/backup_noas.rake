task :backup_noas => :environment do
  BackupNoa.process
end
