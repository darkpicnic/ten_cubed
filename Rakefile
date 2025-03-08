# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

# Task specifically for testing generators
RSpec::Core::RakeTask.new(:generator_spec) do |t|
  t.pattern = "spec/generators/**/*_spec.rb"
end

require "standard/rake"

task default: %i[spec standard]

# Run generator tests specifically
desc "Run generator tests"
task test_generators: :generator_spec
