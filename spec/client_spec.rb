require 'rspec'
require 'client'

describe Client do
 def new_client(attributes = {})
    Client.new(
      {name: "Sodexo",
        type: "Standard"
      }.merge(attributes)
    )
  end

  context "client attributes" do
    it "requires name and type" do
      client = new_client
      expect(client.valid?).to be(true)
    end

    it "empty name is invalid" do
      client = new_client({name:"", type:"Standard"})
      expect(client.valid?).to be(false)
    end

    it "nil name is invalid" do
      client = new_client({name:nil, type:"Standard"})
      expect(client.valid?).to be(false)
    end

    it "nil type is invalid" do
      client = new_client({type:""})
      expect(client.valid?).to be(false)
    end
  end
end