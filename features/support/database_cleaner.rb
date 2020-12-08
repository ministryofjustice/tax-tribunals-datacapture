DatabaseCleaner.strategy = :truncation

Before do
  DatabaseCleaner.clean
end