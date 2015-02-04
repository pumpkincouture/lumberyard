require 'rspec'
require 'client'
require 'spec_helper'

describe Client do

  before :each do
    @client = Client.new
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
    it "makes sure client creation is valid" do
      attributes = ({
        name: "Cleanliving",
        type: "Standard"
        })
      expect(@client.create_client(attributes).valid?).to eq(true)
    end

    it "does not allow creation of invalid clients" do
        attributes = ({
          name: nil,
          type: "Standard"
        })
        expect(@client.create_client(attributes).valid?).to eq(false)
    end

    it "doesn't write invalid client to database" do
      attributes =({
        name: nil,
        type: "Standard"
        })
      expect(@client.create_client(attributes).valid?).to eq(false)
    end
  end
end