require 'rspec'
require 'timesheet'
require 'spec_helper'

describe TimeSheet do

  context "timesheet attributes" do
    it "requires all fields to be valid" do
        timesheet = TimeSheet.create(
        :username => "ddavid",
        :date => "2015/1/11",
        :hours => "2",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(true)
    end

    it "missing project_type is not valid" do
      timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing username is not valid" do
        timesheet = TimeSheet.create(
        :username => nil,
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing year is not valid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "/1/13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing month is not valid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015//13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing day is not valid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing hours is not valid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "project_types" do
    it "type can only be PTO, Billable, or NonBillable" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "whatever")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing a project type is not valid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => nil)
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "timesheet date" do
    it "required date cannot be in the future" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2020/1/13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "required date must be in a valid format" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "13/2015/1",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "writing to a database" do
    it "creates a new timesheet in the database" do
      timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable")
      expect(TimeSheet.last.username).to eq("solak")
    end

    it "created two valid entries in database" do
      expect(TimeSheet.count).to eq(2)
    end
  end
end