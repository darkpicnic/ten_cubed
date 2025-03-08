# frozen_string_literal: true
# Created by AI

require "spec_helper"

RSpec.describe TenCubed::Models::Concerns::TenCubedUser do
  let(:user_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = "users"
      include TenCubed::Models::Concerns::TenCubedUser
      attr_accessor :id, :max_degree
    end
  end

  let(:user) { user_class.new(id: 1, max_degree: 3) }
  let(:friend) { user_class.new(id: 2, max_degree: 3) }
  let(:friend_of_friend) { user_class.new(id: 3, max_degree: 3) }
  let(:third_degree) { user_class.new(id: 4, max_degree: 3) }
  let(:outside_network) { user_class.new(id: 5, max_degree: 3) }

  describe "#my_network" do
    it "caches the network result" do
      expect(user).to receive(:network).with(3).once.and_return([friend, friend_of_friend, third_degree])
      
      result1 = user.my_network
      result2 = user.my_network
      
      expect(result1).to eq([friend, friend_of_friend, third_degree])
      expect(result2).to eq([friend, friend_of_friend, third_degree])
    end
  end

  describe "#degree_of_connection" do
    before do
      allow(friend).to receive(:degree).and_return(1)
      allow(friend_of_friend).to receive(:degree).and_return(2)
      allow(third_degree).to receive(:degree).and_return(3)
      allow(user).to receive(:my_network).and_return([friend, friend_of_friend, third_degree])
    end

    it "returns the degree of connection to a user" do
      expect(user.degree_of_connection(friend)).to eq(1)
      expect(user.degree_of_connection(friend_of_friend)).to eq(2)
      expect(user.degree_of_connection(third_degree)).to eq(3)
    end

    it "returns nil for a user outside the network" do
      expect(user.degree_of_connection(outside_network)).to be_nil
    end
  end

  describe "#in_network?" do
    before do
      allow(user).to receive(:my_network).and_return([friend, friend_of_friend, third_degree])
    end

    it "returns true for a user in the network" do
      expect(user.in_network?(friend)).to be true
      expect(user.in_network?(friend_of_friend)).to be true
      expect(user.in_network?(third_degree)).to be true
    end

    it "returns false for a user outside the network" do
      expect(user.in_network?(outside_network)).to be false
    end
  end

  describe "#network" do
    it "returns an empty array if max_depth is invalid" do
      expect(user.network(0)).to eq([])
      expect(user.network(4)).to eq([])
    end

    it "queries the network with SQL" do
      expect(user_class).to receive(:find_by_sql).and_return([friend, friend_of_friend])
      
      result = user.network(2)
      
      expect(result).to eq([friend, friend_of_friend])
    end
  end
end 