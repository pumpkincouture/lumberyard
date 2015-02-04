require 'rspec'

describe LumberYardHelpers do

  before :each do
    Employee.destroy
    Client.destroy
    Timesheet.destroy
  end

  include LumberYardHelpers

  describe '#admin?' do
    it "finds an admin employee" do
      Employee.create(:first_name => "Diane", :last_name => "Lockhart", :username => "dlockhart", :employee_type => "admin")
      expect(admin?('dlockhart')).to eq(true)
    end
  end

  describe '#non_admin?' do
    it "finds a non_admin employee" do
      Employee.create(:first_name => "Eli", :last_name => "Gold", :username => "egold", :employee_type => "non-admin")
      expect(non_admin?('egold')).to eq(true)
    end
  end

  describe '#employee_exists?' do
    it "returns false if employee not found" do
      expect(employee_exists?('radams')).to eq(false)
    end

    it "returns true if employee is found" do
      Employee.create(:first_name => "Diane", :last_name => "Lockhart", :username => "dlockhart", :employee_type => "admin")
      expect(employee_exists?('dlockhart')). to eq(true)
    end
  end

  describe '#find_employee' do
    it "returns employee object" do
      Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      expect(find_employee('dsmith').employee_type).to eq('admin')
    end
  end

  describe '#get_correct_form' do
    it "returns the first form name according to button selection" do
      expect(get_correct_form("1")).to eq(:log_time)
    end

    it "returns the third form name according to button selection" do
      expect(get_correct_form("3")).to eq(:add_employee)
    end
  end

  describe '#get_all_clients' do
    it "returns all clients in dtabase" do
      Client.create(:name => "Praxair", :type => "Standard")
      Client.create(:name => "Allegra", :type => "Standard")
      expect(get_all_clients.first.name).to eq("Praxair")
    end
  end

  describe '#get_timesheet' do
    it "returns this month's timesheet for logged in employee" do
      expect(get_timesheet.empty?).to eq(true)
    end
  end
end