# frozen_string_literal: true

require_relative "lib/ten_cubed/version"

Gem::Specification.new do |spec|
  spec.name = "ten_cubed"
  spec.version = TenCubed::VERSION
  spec.authors = ["Sebastian Wildwood"]
  spec.email = ["sebastian@lemery.io"]

  spec.summary = "Implementation of the ten_cubed networking system for Rails applications"
  spec.description = "The ten_cubed gem allows you to easily integrate an artificially restricted social graph into your Rails application. It limits users to 10 direct connections and provides a network of up to 1,110 total connections (10 + 100 + 1000) with configurable degree access. Requires PostgreSQL."
  spec.homepage = "https://github.com/darkpicnic/ten_cubed"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = "https://github.com/darkpicnic/ten_cubed"
  spec.metadata["source_code_uri"] = "https://github.com/darkpicnic/ten_cubed"
  spec.metadata["changelog_uri"] = "https://github.com/darkpicnic/ten_cubed/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://github.com/darkpicnic/ten_cubed/blob/main/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "rails", "~> 7.0", ">= 7.0.0"
  spec.add_dependency "activerecord", "~> 7.0", ">= 7.0.0"
  spec.add_dependency "pg", "~> 1.5"

  # Development dependencies
  spec.add_development_dependency "rspec-rails", "~> 7.1.1"
  spec.add_development_dependency "database_cleaner-active_record", "~> 2.2"
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "factory_bot_rails", "~> 6.2"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
  spec.add_development_dependency "generator_spec", "~> 0.9.5"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
