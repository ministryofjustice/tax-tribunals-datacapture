task :mutant => :environment do
  vars = 'NOCOVERAGE=true'
  flags = '--use rspec --fail-fast'

  # TODO: Remove this once all our classes are migrated to the
  # TaxTribs namespace
  classes_to_mutate.each do |klass|
    unless system("#{vars} mutant #{flags} #{klass}")
      raise 'Mutation testing failed'
    end
  end

  # TODO: migrate all service classes into the TaxTribs namespace, so
  # that mutant will test them
  unless system("#{vars} mutant #{flags} TaxTribs*")
    raise 'Mutation testing failed'
  end
end

task(:default).prerequisites << task(:mutant)

private

def classes_to_mutate
  Rails.application.eager_load!
  ApplicationRecord.descendants.map(&:name)
end
