require 'rspec'
require 'rack/test'

describe 'LumberYard App' do
  include Rack::Test::Methods

  context "main page of app" do
    it "displays the title of the app" do
      get '/'

      expect(last_response.status).to eq(200)
    end

    it "asks the user for their username" do
      get '/'

      expect(last_response.status).to eq(200)
    end

    it "redirects to error page if user is not found" do
      post '/username', {"username_name" => 'radams'}
      expect(last_request.path).to eq('/username')
      expect(last_response.status).to eq(200)
    end
  end

  context "main options page for employee" do
    it "display admin page if employee is type admin" do
      post '/username', {"username_name" => 'dlockhart'}
      expect(last_response.status).to eq(200)
    end

    it "displays non admin page if employee is not admin" do
      post '/username', {"username_name" => 'echeesecake'}
      expect(last_response.status).to eq(200)
    end
  end

  context "admin employee chooses an action" do
    it "allows the employee to log time" do
      post '/selection', {"option" => "1"}
      expect(last_request.path).to eq('/selection')
      expect(last_response.status).to eq(200)
    end

    it "allows the employee to request time report" do
      post '/selection', {"option" => "2"}
      expect(last_response.status).to eq(200)
    end

    it "allows the employee to add an employee" do
      post '/selection', {"option" => "3"}
      expect(last_response.status).to eq(200)
    end

    it "allows the employee to add a client" do
      post '/selection', {"option" => "4"}
      expect(last_response.status).to eq(200)
    end

    it "allows the employee to request employee report" do
      post '/selection', {"option" => "5"}
      expect(last_response.status).to eq(200)
    end
  end

  context "non-admin employee chooses an action" do
    it "allows the employee to log time" do
      post '/selection', {"option" => "1"}
      expect(last_response.status).to eq(200)
    end

    it "allows the employee to request time report" do
      post '/selection', {"option" => "2"}
      expect(last_response.status).to eq(200)
    end
  end

  context "admin employee can add employee" do
    it "redirects if input is invalid" do
      post '/add_employee', {
        "first_name" => nil,
        "last_name" => "Olak",
        "username" => "solak",
        "employee_type" => 'non-admin'}
      expect(last_request.path).to eq('/add_employee')
      expect(last_response.status).to eq(302)
    end

    it "displays success page if input is valid" do
      post '/add_employee', {
        "first_name" => "Sylwia",
        "last_name" => "Olak",
        "username" => "solak",
        "employee_type" => 'non-admin'}
      expect(last_response.status).to eq(200)
    end
  end

  context "admin employee can add client" do
    it "redirects if input is invalid" do
      post '/add_client', {
        "name" => nil,
        "type" => "Standard"
        }
      expect(last_request.path).to eq('/add_client')
      expect(last_response.status).to eq(302)
    end

    it "displays success page if input is valid" do
       post '/add_client', {
        "name" => "Allegra",
        "type" => "Standard"
        }
      expect(last_response.status).to eq(200)
    end
  end

  context "employee can bill time" do
    it "redirects if input is invalid" do
      post '/billing', {
        "username" => "",
        "date" => "2015/1/3",
        "hours" => "",
        "project_type" => "non-billable",
        "client" => ""
      }
      expect(last_request.path).to eq('/billing')
      expect(last_response.status).to eq(302)
    end

    it "displays success page if input is valid" do
        post '/billing', {
        "username" => "dsmith",
        "date" => "2015/1/15",
        "hours" => "3",
        "project_type" => "non-billable",
        "client" => ""
      }
      expect(last_response.status).to eq(200)
    end

    it "redirects if client input is invalid" do
        post '/billing', {
        "username" => "dsmith",
        "date" => "2015/1/15",
        "hours" => "3",
        "project_type" => "billable",
        "client" => ""
      }
      expect(last_request.path).to eq('/billing')
      expect(last_response.status).to eq(302)
    end

    it "displays success page if client input is valid" do
        post '/billing', {
        "username" => "dsmith",
        "date" => "2015/1/15",
        "hours" => "3",
        "project_type" => "billable",
        "client" => "Allegra"
      }
      expect(last_response.status).to eq(200)
    end
  end
end