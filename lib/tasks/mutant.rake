# TODO: migrate all service classes into the `TaxTribs` namespace, so
# that mutant will test them. Remove `ApplicationRecord.descendants`
# once all our classes are migrated to the `TaxTribs` namespace.
#
# Pass a match expression as an optional argument to only run mutant
# on classes that match. Example: `rake mutant TaxTribs::ZendeskSender`

task :mutant => :environment do
  vars = 'NOCOVERAGE=true'
  flags = '--use rspec --fail-fast'

  classes_to_mutate.each do |klass|
    unless system("#{vars} mutant #{flags} #{klass}")
      raise 'Mutation testing failed'
    end
  end

  exit
end

task(:default).prerequisites << task(:mutant)

private

def classes_to_mutate
  Rails.application.eager_load!
  Array(ARGV[1]).presence || ApplicationRecord.descendants.map(&:name) + ['TaxTribs*']
end
