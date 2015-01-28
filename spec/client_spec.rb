require 'rspec'
require 'client'
require 'spec_helper'

describe Client do
  context "client attributes" do
    it "requires name and type" do
      client = Client.create(:name => "Praxair", :type => "Standard")
      expect(client.valid?).to be(true)
    end

    it "empty name is invalid" do
      client = Client.create(:name => "", :type => "Standard")
      expect(client.valid?).to be(false)
    end

    it "nil name is invalid" do
      client = Client.create(:name => nil, :type => "Standard")
      expect(client.valid?).to be(false)
    end

    it "nil type is invalid" do
      client = Client.create(:name => "Praxair", :type => nil)
      expect(client.valid?).to be(false)
    end
  end
end