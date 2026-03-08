# frozen_string_literal: true

# Created by AI

require "active_record"
require "active_support/concern"

module TenCubed
  module Models
    module Concerns
      module TenCubedUser
        extend ActiveSupport::Concern

        included do
          has_many :connections, dependent: :destroy, class_name: TenCubed.configuration.connection_class_name, foreign_key: "user_id"
          has_many :friends, through: :connections, source: :target
        end

        # Returns the user's network up to the user's max_degree
        def my_network
          @my_network ||= {}
          @my_network[max_degree] ||= network(max_degree)
        end

        # Returns the degree of connection between self and another user
        def degree_of_connection(user)
          my_network.each do |connection|
            return connection.degree if connection.id == user.id
          end
          nil # Return nil if no connection exists
        end

        # Checks if a user is in the current user's network
        def in_network?(user)
          my_network.include?(user)
        end

        # Returns a network of connections up to the specified max_depth
        def network(max_depth = 3)
          return [] if max_depth <= 0 || max_depth > 3

          user_table = TenCubed.configuration.user_table_name

          sql = <<-SQL
          WITH RECURSIVE friend_of_friend AS (
            SELECT connections.target_id, #{user_table}.max_degree, 1 AS depth
            FROM #{TenCubed.configuration.connection_table_name}
            JOIN #{user_table} ON connections.target_id = #{user_table}.id
            WHERE connections.user_id = :user_id
            UNION ALL
            SELECT connections.target_id, #{user_table}.max_degree, depth + 1
            FROM #{TenCubed.configuration.connection_table_name}
            JOIN #{user_table} ON connections.target_id = #{user_table}.id
            JOIN friend_of_friend ON connections.user_id = friend_of_friend.target_id
            WHERE depth < :max_depth
              AND depth < #{user_table}.max_degree -- Only add users that can appear at current depth.
          )
          SELECT DISTINCT ON (#{user_table}.id) #{user_table}.*, friend_of_friend.depth AS degree
          FROM #{user_table}
          JOIN friend_of_friend ON #{user_table}.id = friend_of_friend.target_id
          WHERE #{user_table}.id != :user_id
          ORDER BY #{user_table}.id, friend_of_friend.depth;
          SQL

          connections = self.class.find_by_sql([sql, {user_id: id, max_depth: max_depth}])
          connections.uniq { |c| c.id }
        end
      end
    end
  end
end
