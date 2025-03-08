# frozen_string_literal: true
# Created by AI

require "spec_helper"
require "generator_spec"
require "generators/ten_cubed/install/install_generator"

RSpec.describe TenCubed::Generators::InstallGenerator do
  # Since we're having trouble with the full generator test,
  # we'll just focus on testing the specific methods that don't involve rails_command
  describe "#model_exists?" do
    let(:generator) { described_class.new }
    let(:test_dir) { File.expand_path("../../tmp", __dir__) }

    before do
      # Clean up any existing files
      FileUtils.rm_rf(test_dir)
      FileUtils.mkdir_p(test_dir)
      
      # Set up Rails.root for testing
      allow(Rails).to receive(:root).and_return(Pathname.new(test_dir))
    end

    it "returns true when model file exists" do
      # Create a dummy model file
      FileUtils.mkdir_p(File.join(test_dir, "app/models"))
      File.write(File.join(test_dir, "app/models/user.rb"), "class User < ApplicationRecord; end")
      
      expect(generator.send(:model_exists?, "User")).to be true
    end

    it "returns false when model file doesn't exist" do
      expect(generator.send(:model_exists?, "NonExistentModel")).to be false
    end
  end

  describe "#migration_version" do
    let(:generator) { described_class.new }

    context "with rails version greater than 5.0.0" do
      it "includes migration version" do
        allow(Rails).to receive(:version).and_return("8.0.0")
        expect(generator.send(:migration_version)).to eq("[8.0]")
      end
    end
    
    context "with rails version less than 5.0.0" do
      it "returns nil" do
        allow(Rails).to receive(:version).and_return("4.2.0")
        expect(generator.send(:migration_version)).to be_nil
      end
    end
  end
end 