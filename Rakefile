require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task :version do
  require './lib/version'
  puts Version.current
  exit 0
end

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:spec_report) do |t|
  t.pattern = './spec/**/*_spec.rb'
  t.rspec_opts = %w[--format progress --format RspecJunitFormatter --out reports/spec/rspec.xml]
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
  task.requires << 'rubocop-rspec'
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = ['features', '--publish-quiet', '--tags \'not @wip\'']
end

Cucumber::Rake::Task.new(:acceptance_report) do |task|
  task.cucumber_opts = ['features', '--publish-quiet', '--tags \'not @wip and not @local\'', '--format pretty',
                        '--format html -o reports/cucumber.html']
end

Cucumber::Rake::Task.new(:feature_indev) do |task|
  task.cucumber_opts = ['features', '--tags \'@indev\'']
end

task build_server: %i[rubocop spec_report]

task default: %i[cucumber spec rubocop]
