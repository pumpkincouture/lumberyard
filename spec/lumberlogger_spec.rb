require 'rspec'
require 'lumberlogger'
require 'spec_helper'

describe LumberLogger do

  before :each do
    @lumberlogger = LumberLogger.new
  end

  context "writing to database" do
    it "writes valid employee to database" do
      @lumberlogger.create_employee({
        first_name: "Eli",
        last_name: "Cheesecake",
        username: "echeesecake",
        employee_type: "non-admin"
        })
      expect(Employee.last.username).to eq("echeesecake")
    end

    it "writes valid client to database" do
      @lumberlogger.create_client({
        name: "CleanLiving",
        type: "Standard"
        })
      expect(Client.last.name).to eq("CleanLiving")
    end

    it "writes valid timesheet to database" do
      @lumberlogger.create_timesheet({
        username: "egold",
        date: "2015/1/3",
        hours: "5",
        project_type: "non-billable"
        })
      expect(TimeSheet.last.project_type).to eq("non-billable")
    end

    it "does not write invalid employee to database" do
      @lumberlogger.create_employee({
        first_name: "Eli",
        last_name: "Cheesecake",
        username: nil,
        employee_type: "non-admin"
        })
      expect(Employee.last.username).to_not eq(nil)
    end

    it "does not write invalid client to database" do
      @lumberlogger.create_client({
        name: "",
        type: "Standard"
        })
      expect(Client.last.name).to_not eq("")
    end

    it "does not write invalid timesheet to database" do
      new_timesheet = @lumberlogger.create_timesheet({
        username: "egold",
        date: "2015//3",
        hours: "5",
        project_type: "non-billable"
        })
      expect(TimeSheet.last.date).to_not eq("2015//3")
    end
  end

  context "finding records from database" do
    it "returns false if the user record does not exist" do
      expect(@lumberlogger.employee_exists?('radams')).to eq(false)
    end

    it "returns true if the user record exists" do
      expect(@lumberlogger.employee_exists?('Dsmith')).to eq(true)
    end

    it "returns false if the client does not exist" do
      expect(@lumberlogger.client_exists?('aflac')).to eq(false)
    end

    it "returns true if the client exists" do
      expect(@lumberlogger.client_exists?('Praxair')).to eq(true)
    end

    it
  end
end
