require 'rspec'
require 'employee'
require 'spec_helper'

describe Employee do

  before :each do
    Employee.destroy
  end

  context "employee_type" do
    it 'admin is valid' do
      employee = Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      expect(employee.valid?).to eq(true)
    end

    it 'non-admin is valid' do
      employee = Employee.create(:first_name => "Eli", :last_name => "Gold", :username => "egold", :employee_type => "non-admin")
      expect(employee.valid?).to eq(true)
    end

    it 'anything else is invalid' do
      employee = Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "something")
      expect(employee.valid?).to eq(false)
    end
  end

  context "presence of attributes" do
    it "all input fields required" do
      employee = Employee.create(:first_name => "Diane", :last_name => "Lockhart", :username => "dlockhart", :employee_type => "admin")
      expect(employee.valid?).to eq(true)
    end

    it "missing input fields are invalid" do
      employee = Employee.create(:first_name => "", :last_name => "Smith", :username => "nil", :employee_type => "admin")
      expect(employee.valid?).to eq(false)
    end

    it "missing first_name field is invalid" do
      employee = Employee.create(:first_name => "", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      expect(employee.valid?).to eq(false)
    end
  end

  context "creating a new employee" do
    it "only allows valid employees to be created" do
      @employee = Employee.new
      attributes = ({
        first_name: "Eli",
        last_name: "Cheesecake",
        username: "echeesecake",
        employee_type: "non-admin",
        })
      expect(@employee.create_employee(attributes).valid?).to eq(true)
    end

    it "does not allow invalid employees to be created" do
      @employee = Employee.new
      attributes = ({
        first_name: "",
        last_name: "Cheesecake",
        username: "echeesecake",
        employee_type: "non-admin",
        })
      expect(@employee.create_employee(attributes).valid?).to eq(false)
    end
  end

  context "checking employee type" do
    it "returns true if an employee is of admin type" do
      @employee = Employee.new
      Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      expect(@employee.admin?('dsmith')).to eq(true)
    end

    it "returns false is employee is not of admin type" do
      @employee = Employee.new
      Employee.create(:first_name => "Eli", :last_name => "Gold", :username => "egold", :employee_type => "non-admin")
      expect(@employee.admin?('egold')).to eq(false)
    end

    it "returns true if an employee is of non-admin type" do
      @employee = Employee.new
      Employee.create(:first_name => "Eli", :last_name => "Gold", :username => "egold", :employee_type => "non-admin")
      expect(@employee.non_admin?('egold')).to eq(true)
    end

    it "returns false if an employee is not of non-admin type" do
      @employee = Employee.new
      Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      expect(@employee.non_admin?('dsmith')).to eq(false)
    end
  end

  context "finding employee in database" do
    it "returns true if employee is found in database" do
      @employee = Employee.new
      Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      expect(@employee.employee_exists?('dsmith')).to eq(true)
    end

    it "returns false if employee is not found" do
      @employee = Employee.new
      expect(@employee.employee_exists?('dsmith')).to eq(false)
    end

    it "returns the Employee object if found" do
      @employee = Employee.new
      Employee.create(:first_name => "David", :last_name => "Smith", :username => "dsmith", :employee_type => "admin")
      expect(@employee.find_employee('dsmith').first_name).to eq('David')
    end
  end
end