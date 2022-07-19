task :backup_noas => :environment do
  BackupNoa.process
end

task :uncreated_pdfs => :environment do
  TaxTribs::RebuildPdf.rebuild
end
