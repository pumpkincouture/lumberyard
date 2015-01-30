require 'rspec'
require 'rack/test'

describe 'LumberYard App' do
  include Rack::Test::Methods

  context "main page of app" do
    it "displays the title of the app" do
      get '/'
      expect(last_response.body).to include("LumberYard")
    end

    it "asks the user for their username" do
      get '/'
      expect(last_response.body).to include("Please enter your employee username to get started.")
    end

    it "redirects to error page if user is not found" do
      post '/username', {"username_name" => 'radams'}
      expect(last_response.body).to include("That username is invalid. Please input your username.")
    end

    it "leads to success page if user is found" do
      post '/username', {"username_name" => "dlockhart"}
      expect(last_response.body).to include("You're logged in!")
    end
  end
end