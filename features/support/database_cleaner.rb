DatabaseCleaner.strategy = :truncation
DatabaseCleaner.url_allowlist = ['postgresql://postgres@db/tax-tribunals-datacapture']

Before do
  DatabaseCleaner.clean
end