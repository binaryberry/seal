begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # no rspec available
end

begin
  require 'jsonlint/rake_task'
  JsonLint::RakeTask.new do |t|
    t.paths = %w(
    *.json
    )
  end
rescue LoadError
  # no jsonlint available
end

task :default => [
  :jsonlint,
  :spec,
]
