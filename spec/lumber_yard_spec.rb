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
      expect(last_response.status).to eq(302)
    end

    it "displays non admin page if employee is not admin" do
      Employee.create(:first_name => "Eli", :last_name => "Gold", :username => "egold", :employee_type => "non-admin")
      post '/username', {"username_name" => 'egold'}
      expect(last_response.status).to eq(302)
    end
  end

  context "admin employee can add employee" do
    it "directs back to employee/new page with error message if input is invalid" do
      post '/employees', {
        "first_name" => nil,
        "last_name" => "Olak",
        "username" => "solak",
        "employee_type" => 'non-admin'}
      expect(last_request.path).to eq('/employees')
      expect(last_response.status).to eq(302)
    end

    it "redirects to home page with success message if input is valid" do
      post '/employees', {
        "first_name" => "Sylwia",
        "last_name" => "Olak",
        "username" => "solak",
        "employee_type" => 'non-admin'}
      expect(last_response.status).to eq(302)
    end
  end

  context "admin employee can add client" do
    it "redirects back to client/new page with error message if input is invalid" do
      post '/clients', {
        "name" => nil,
        "type" => "Standard"
        }
      expect(last_request.path).to eq('/clients')
      expect(last_response.status).to eq(302)
    end

    it "redirects to home page with success message if input is valid" do
       post '/clients', {
        "name" => "Allegra",
        "type" => "Standard"
        }
      expect(last_response.status).to eq(302)
    end
  end

  context "employee can bill time" do
    before :each do
      rack_mock_session.cookie_jar[:employee] = "dsmith"
    end

    it "redirects back to employee/new page with error message if input is invalid" do
      employee_username = current_session.rack_session[:employee_username] = "dsmith"
      post '/timesheets', {
        "username" => employee_username,
        "date" => "2015/1/3",
        "hours" => "",
        "project_type" => "non-billable",
        "client" => ""}

      expect(last_request.path).to eq('/timesheets')
      expect(last_response.status).to eq(302)
    end

    it "redirects to home page with success message if input is valid" do
        employee_username = current_session.rack_session[:employee_username] = "dsmith"
        post '/timesheets', {
        "username" => employee_username,
        "date" => "2015/1/15",
        "hours" => "3",
        "project_type" => "non-billable",
        "client" => ""
      }
      expect(last_response.status).to eq(302)
    end
  end
end