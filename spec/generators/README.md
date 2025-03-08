# Generator Tests

This directory contains tests for the Rails generators included in the ten_cubed gem.

## Running Generator Tests

You can run the generator tests using the following Rake task:

```bash
bundle exec rake test_generators
```

Or run them directly with RSpec:

```bash
bundle exec rspec spec/generators
```

## Test Structure

The generator tests verify that:

1. The generators create the expected files and migrations
2. The files contain the expected content
3. The generators handle different Rails versions correctly
4. Edge cases (like missing user models) are handled properly

## Generator-Specific Tests

- `user_generator_spec.rb` - Tests for the `ten_cubed:user` generator
- `connection_generator_spec.rb` - Tests for the `ten_cubed:connection` generator
- `install_generator_spec.rb` - Tests for the `ten_cubed:install` generator

## Adding New Generator Tests

When adding a new generator to the gem, be sure to:

1. Create a corresponding test file in this directory
2. Include tests for all generator actions and methods
3. Test with different Rails versions if applicable
4. Test both success cases and edge cases 