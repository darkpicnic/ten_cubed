# frozen_string_literal: true

require_relative "lib/ten_cubed/version"

Gem::Specification.new do |spec|
  spec.name = "ten_cubed"
  spec.version = TenCubed::VERSION
  spec.authors = ["Seb"]
  spec.email = ["sebastian@lemery.io"]

  spec.summary = "Implementation of the ten_cubed networking system for Rails applications"
  spec.description = "The ten_cubed gem allows you to easily integrate an artificially restricted social graph into your Rails application. It limits users to 10 direct connections and provides a network of up to 1,110 total connections (10 + 100 + 1000) with configurable degree access. Requires PostgreSQL."
  spec.homepage = "https://github.com/lemeryfertitta/ten_cubed"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

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
  spec.add_dependency "rails", ">= 6.0.0"
  spec.add_dependency "activerecord", ">= 6.0.0"
  spec.add_dependency "pg", "~> 1.2"

  # Development dependencies
  spec.add_development_dependency "rspec-rails", "~> 5.0"
  spec.add_development_dependency "database_cleaner-active_record", "~> 2.0"
  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "factory_bot_rails", "~> 6.2"
  spec.add_development_dependency "simplecov", "~> 0.21.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
