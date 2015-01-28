require 'rspec'
require 'employee'
require 'spec_helper'

describe Employee do

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
end