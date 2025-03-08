# frozen_string_literal: true

# Created by AI

require "spec_helper"
require "generator_spec"
require "generators/ten_cubed/connection/connection_generator"

RSpec.describe TenCubed::Generators::ConnectionGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __dir__)

  before do
    prepare_destination
    allow(Rails).to receive(:version).and_return("8.0.0")
  end

  it "creates a Connection model" do
    run_generator
    assert_file "app/models/connection.rb" do |content|
      assert_match(/class Connection < ApplicationRecord/, content)
      assert_match(/belongs_to :user/, content)
      assert_match(/belongs_to :target, class_name: "User"/, content)
      assert_match(/validate :ensure_user_has_less_than_max_connections/, content)
      assert_match(/validate :ensure_target_is_not_self/, content)
    end
  end

  it "creates a migration for connections table" do
    run_generator
    assert_migration "db/migrate/create_connections.rb" do |migration|
      assert_match(/create_table :connections/, migration)
      assert_match(/t.references :user, null: false, foreign_key: true/, migration)
      assert_match(/t.references :target, null: false, foreign_key: { to_table: :users }/, migration)
      assert_match(/t.timestamps/, migration)
      assert_match(/add_index :connections, \[:user_id, :target_id\], unique: true/, migration)
    end
  end

  describe "#migration_version" do
    context "with rails version greater than 5.0.0" do
      it "includes migration version" do
        allow(Rails).to receive(:version).and_return("8.0.0")
        generator = described_class.new
        expect(generator.send(:migration_version)).to eq("[8.0]")
      end
    end

    context "with rails version less than 5.0.0" do
      it "returns nil" do
        allow(Rails).to receive(:version).and_return("4.2.0")
        generator = described_class.new
        expect(generator.send(:migration_version)).to be_nil
      end
    end
  end
end
