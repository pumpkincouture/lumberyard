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
        :project_type => "non-billable",
        )
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

    it "billable type can only have valid client" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable",
        :client => "United"
        )
      expect(timesheet.valid?).to eq(true)
    end

    it "billable type with empty client is not valid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "Billable",
        :client => ""
        )
      expect(timesheet.valid?).to eq(false)
    end

    it "billable type with nil client is not valid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable",
        :client => nil
        )
      expect(timesheet.valid?).to eq(false)
    end

    it "if billable type with no client, is invalid" do
        timesheet = TimeSheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable"
        )
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
end