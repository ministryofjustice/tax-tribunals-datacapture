task :mutant => :environment do
  classes_to_mutate.each do |klass|
    vars = 'NOCOVERAGE=true'
    flags = '--use rspec --fail-fast'
    unless system("#{vars} mutant #{flags} #{klass}")
      raise 'Mutation testing failed'
    end
  end
end

task(:default).prerequisites << task(:mutant)

private

def classes_to_mutate
  Rails.application.eager_load!
  ApplicationRecord.descendants.map(&:name)
end
