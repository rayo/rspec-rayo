require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "rspec-tropo2"
  gem.homepage = "http://github.com/tropo/rspec-tropo2"
  gem.license = "MIT"
  gem.summary = "Rspec2 for Tropo2"
  gem.description = "Rspec2 Matchers for Tropo2"
  gem.email = "jsgoecke@voxeo.com"
  gem.authors = ["Jason Goecke"]
  gem.add_development_dependency 'rspec', '>= 2.6.0'
  gem.add_development_dependency 'punchblock', '>= 0.1.0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
