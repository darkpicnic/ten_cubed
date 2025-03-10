# ten_cubed
[![Ruby Gem CI](https://github.com/darkpicnic/ten_cubed/actions/workflows/main.yml/badge.svg)](https://github.com/darkpicnic/ten_cubed/actions/workflows/main.yml)

A Ruby on Rails gem implementing the ten_cubed networking system - an artificially restricted social graph that limits users to 10 direct connections with a maximum network size of 1,110 total connections (10 + 100 + 1000).

The ten_cubed system promotes healthier social interactions by imposing natural limits on connection growth, limiting viral content spread, and eliminating influencer dynamics.

## Project Status

⚠️ **ACTIVE DEVELOPMENT** ⚠️

This project is currently in active development. APIs and functionality may change without notice. Breaking changes are possible between versions. While we encourage testing and contributions, this gem is not yet recommended for production environments without thorough evaluation.

## Requirements

* Ruby 3.2+
* Rails 7.0+
* PostgreSQL database (required for the recursive CTE queries used by the gem)

## About

The ten_cubed networking system is based on three key concepts:

1. Users can have no more than 10 connections in their immediate network
2. Users have three levels of their network (1st, 2nd, and 3rd degree) with a theoretical maximum of 1,110 total connections
3. Users can set the maximum degree allowed for different activities within your app

For more details on the ten_cubed concept, see: [https://highlyprobable.io/articles/ten-cubed](https://highlyprobable.io/articles/ten-cubed)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ten_cubed'
```

And then execute:

```bash
$ bundle install
```

Then run the installer:

```bash
$ rails generate ten_cubed:install
```

The installer will:
- Create an initializer at `config/initializers/ten_cubed.rb`
- Check if a User model exists
  - If it exists: Add a migration for the `max_degree` column and inject the TenCubed concern
  - If it doesn't exist: Generate a new User model with TenCubed functionality
- Check if a Connection model exists
  - If it exists: Raise an error (you need to rename or remove the existing model)
  - If it doesn't exist: Generate the Connection model for TenCubed
- Install all required migrations

After running the installer, don't forget to run:

```bash
$ rails db:migrate
```

### Manual Setup (Alternative)

If you prefer to set up the components individually:

```bash
# Generate the User model (if you don't already have one)
$ rails generate ten_cubed:user

# Generate the Connection model
$ rails generate ten_cubed:connection

# Run migrations
$ rails db:migrate
```

## Usage

### Configuration

You can configure TenCubed in the initializer file at `config/initializers/ten_cubed.rb`:

```ruby
TenCubed.configure do |config|
  # Maximum number of direct connections a user can have
  # Default: 10
  config.max_direct_connections = 10

  # Maximum network depth for querying connections
  # Default: 3
  config.max_network_depth = 3

  # Table name for connections
  # Default: :connections
  config.connection_table_name = :connections
end
```

### User Model

If you already have a User model, the `ten_cubed:install` generator will add the `max_degree` column to your users table automatically. If you create a User model with the `ten_cubed:user` generator, the model will include the TenCubed functionality by default.

User models will have the following methods:

#### `my_network`

Returns the user's network up to their `max_degree` setting.

```ruby
current_user.my_network
# => [<User>, <User>, ...] (array of users in the network)
```

#### `degree_of_connection(user)`

Returns the degree of connection between the current user and another user.

```ruby
current_user.degree_of_connection(other_user)
# => 1 (direct connection)
# => 2 (friend of friend)
# => 3 (third-degree connection)
# => nil (not connected)
```

#### `in_network?(user)`

Checks if a user is in the current user's network.

```ruby
current_user.in_network?(other_user)
# => true or false
```

#### `network(max_depth = 3)`

Returns the user's network up to the specified depth (1-3).

```ruby
current_user.network(2)
# => [<User>, <User>, ...] (users within 2 degrees)
```

### Connection Model

The `Connection` model enforces the ten_cubed constraints:

1. A user cannot have more than 10 connections
2. A user cannot connect to themselves

To create a connection between two users:

```ruby
TenCubed::Connection.create(user: current_user, target: other_user)
```

### Example Usage

Here's an example of how you might use ten_cubed in a controller:

```ruby
class PostsController < ApplicationController
  def index
    # Show posts only from users in the current user's network
    @posts = Post.where(user_id: current_user.my_network.pluck(:id) + [current_user.id])
  end

  def show
    @post = Post.find(params[:id])
    
    # Check if the current user can access this post based on connection degree
    unless current_user.id == @post.user_id || 
           (current_user.in_network?(@post.user) && 
            current_user.degree_of_connection(@post.user) <= @post.visibility_degree)
      flash[:alert] = "You don't have permission to view this post"
      redirect_to posts_path
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Disclosure of AI generated content
The core functionality of ten_cubed was written by myself, however, this gem was almost entirely AI generated through Cursor + Claude 3.7. I've added specific strings throughout the project to indicate when files were entirely written by AI (though some of these are actually copied from my direct input). There is almost certainly some head scratchers in this repository; feel free to submit PRs if something seems really off.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/darkpicnic/ten_cubed.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

