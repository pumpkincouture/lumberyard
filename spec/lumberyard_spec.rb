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
  end

  context "main options page for employee" do
    it "display admin page if employee is type admin" do
      post '/username', {"username_name" => 'dlockhart'}
      expect(last_response.body).to include("Welcome, Diane")
      expect(last_response.body).to include("Add client")
    end

    it "displays non admin page if employee is not admin" do
      post '/username', {"username_name" => 'echeesecake'}
      expect(last_response.body).to_not include("Add client")
      expect(last_response.body).to include("Welcome, Eli")
    end
  end
end