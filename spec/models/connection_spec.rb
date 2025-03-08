# frozen_string_literal: true
# Created by AI

require "spec_helper"

RSpec.describe TenCubed::Connection, type: :model do
  describe "validations" do
    let(:user1) { User.create!(name: "User 1", email: "user1@example.com") }
    let(:user2) { User.create!(name: "User 2", email: "user2@example.com") }

    subject { TenCubed::Connection.new(user: user1, target: user2) }

    before do
      allow(TenCubed.configuration).to receive(:max_direct_connections).and_return(10)
      # Make sure user1 has connections
      allow(user1).to receive(:connections).and_return(double("Connections", count: 5))
    end

    context "when user has less than max connections" do
      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "when user has max connections" do
      before do
        allow(user1).to receive(:connections).and_return(double("Connections", count: 10))
      end

      it "is invalid" do
        expect(subject).not_to be_valid
        expect(subject.errors[:user]).to include("can't have more than 10 connections")
      end
    end

    context "when target is the same as user" do
      subject { TenCubed::Connection.new(user: user1, target: user1) }

      it "is invalid" do
        expect(subject).not_to be_valid
        expect(subject.errors[:target]).to include("can't be the same as user")
      end
    end
  end
end 