require 'rspec'
require 'client'
require 'spec_helper'

describe Client do

  before :each do
    Client.destroy
  end

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

  context "creating clients" do
    it "only allows valid client creation" do
      @client = Client.new
      attributes = ({
        name: "Cleanliving",
        type: "Standard"
        })
      expect(@client.create_client(attributes).valid?).to eq(true)
    end

    it "does not allow invalid clients to be written to database" do
      @client = Client.new
      attributes =({
        name: nil,
        type: "Standard"
        })
      expect(@client.create_client(attributes).valid?).to eq(false)
    end
  end

  context "finding clients in the database" do
    it "finds all clients located in the database" do
      @client = Client.new
      Client.create(:name => "Praxair", :type => "Standard")

      expect(@client.get_all_clients.first.name).to eq("Praxair")
      expect(@client.get_all_clients.count).to eq(1)
    end
  end
end