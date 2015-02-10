require 'rspec'
require 'rack/test'

describe 'LumberYard App' do
  include Rack::Test::Methods

  before :each do
    Employee.destroy
    Client.destroy
    Timesheet.destroy
  end

  def get_correct_form(choice)
    forms = ["log_time", "time_report", "add_employee", "add_client", "employee_report"]
    forms[choice.to_i - 1].to_sym
  end

  context "main page of app" do
    it "displays the title of the app" do
      get '/'

      expect(last_response.status).to eq(200)
    end

    it "asks the user for their username" do
      get '/'

      expect(last_response.status).to eq(200)
    end

    it "displays home page with error message if user is not found" do
      post '/username', {"username_name" => 'radams'}
      expect(last_request.path).to eq('/username')
      expect(last_response.status).to eq(200)
    end
  end

  context "main options page for employee" do
    it "display admin page if employee is type admin" do
      Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      post '/username', {"username_name" => 'dsmith'}
      expect(last_response.status).to eq(200)
    end

    it "displays non admin page if employee is not admin" do
      Employee.create(:first_name => "Eli", :last_name => "Gold", :username => "egold", :employee_type => "non-admin")
      post '/username', {"username_name" => 'egold'}
      expect(last_response.status).to eq(200)
    end
  end

  context "rendering page templates based on user choice" do
    it "allows the employee to log time" do
      option = "1"
      post '/selection', option
      expect(last_request.path).to eq('/selection')
      expect(last_response.status).to eq(200)
      expect(get_correct_form(option)).to eq(:log_time)
    end

    it "allows the employee to request time report" do
      option = "2"
      post '/selection', option
      expect(last_response.status).to eq(200)
      expect(get_correct_form(option)).to eq(:time_report)
    end

    it "allows the employee to add an employee" do
      option = "3"
      post '/selection', option
      expect(last_response.status).to eq(200)
      expect(get_correct_form(option)).to eq(:add_employee)
    end

    it "allows the employee to add a client" do
      option = "4"
      post '/selection', option
      expect(last_response.status).to eq(200)
      expect(get_correct_form(option)).to eq(:add_client)
    end

    it "allows the employee to request employee report" do
      option = "5"
      post '/selection', option
      expect(last_response.status).to eq(200)
      expect(get_correct_form(option)).to eq(:employee_report)
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