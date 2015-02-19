require 'rspec'
require 'timesheet'
require 'spec_helper'

describe Timesheet do

  before :each do
    Timesheet.destroy
  end

  context "timesheet attributes" do
    it "requires all fields to be valid" do
      timesheet = Timesheet.create(
        :username => "ddavid",
        :date => "2015/1/11",
        :hours => "2",
        :project_type => "non-billable",
        :client => ""
        )
      expect(timesheet.valid?).to eq(true)
    end

    it "missing project_type is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing username is not valid" do
      timesheet = Timesheet.create(
        :username => nil,
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing year is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "/1/13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing month is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015//13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing day is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "missing hours is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "project_types" do
    it "type can only be PTO, Billable, or NonBillable" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "whatever")
      expect(timesheet.valid?).to eq(false)
    end

    it "billable type can only have valid client" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable",
        :client => "United"
        )
      expect(timesheet.valid?).to eq(true)
    end

    it "Billable type can only have valid client" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "Billable",
        :client => "United"
        )
      expect(timesheet.valid?).to eq(true)
    end

    it "billable type with empty client is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "Billable",
        :client => ""
        )
      expect(timesheet.valid?).to eq(false)
    end

    it "billable type with nil client is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "billable",
        :client => nil
        )
      expect(timesheet.valid?).to eq(false)
    end

    it "pto project with empty client is valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "pto",
        :client => ""
        )
      expect(timesheet.valid?).to eq(true)
     end

    it "pto project with client is invalid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "pto",
        :client => "Kraft"
        )
      expect(timesheet.valid?).to eq(false)
     end

    it "non-billable project with empty client is valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "non-billable",
        :client => ""
        )
      expect(timesheet.valid?).to eq(true)
     end

    it "non-billable project with client is invalid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => "non-billable",
        :client => "Sunkist"
        )
      expect(timesheet.valid?).to eq(false)
     end

    it "missing a project type is not valid" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2015/1/13",
        :hours => "6",
        :project_type => nil)
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "timesheet date" do
    it "required date cannot be in the future" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "2020/1/13",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end

    it "required date must be in a valid format" do
      timesheet = Timesheet.create(
        :username => "solak",
        :date => "13/2015/1",
        :hours => "6",
        :project_type => "billable")
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "creating a new timesheet" do
    it "only a valid timesheet can be created" do
      @timesheet = Timesheet.new
      attributes =  ({
        username: "egold",
        date: "2015/1/3",
        hours: "5",
        project_type: "non-billable",
        client: ""
        })
      expect(@timesheet.create_timesheet(attributes).valid?).to eq(true)
    end

    it "does not allow creation of an invalid timesheet" do
      @timesheet = Timesheet.new
      attributes = ({
        username: "egold",
        date: "2015//3",
        hours: "5",
        project_type: "non-billable",
        client: ""
        })
      expect(@timesheet.create_timesheet(attributes).valid?).to eq(false)
    end
  end

  context "finding timesheets in the database" do
    it "finds a timesheet for the month of February for username egold" do
      @timesheet = Timesheet.new
      Timesheet.create(
        :username => "egold",
        :date => "2015/2/3",
        :hours => "5",
        :project_type => "non-billable",
        :client => ""
      )

      Timesheet.create(
        :username => "egold",
        :date => "2015/1/3",
        :hours => "8",
        :project_type => "pto",
        :client => ""
      )
      expect(@timesheet.get_timesheet_for_employee("2", "egold")[0].date).to eq("2015/2/3")
    end


    it "finds all timesheets for month of February" do
      @timesheet = Timesheet.new
      Timesheet.create(
        :username => "egold",
        :date => "2015/2/3",
        :hours => "8",
        :project_type => "pto",
        :client => ""
      )

      Timesheet.create(
        :username => "egold",
        :date => "2015/2/10",
        :hours => "2",
        :project_type => "non-billable",
        :client => ""
      )
      expect(@timesheet.get_timesheet("2")[0].date).to eq("2015/2/3")
    end

    it "finds no timesheets for the month of February" do
      @timesheet = Timesheet.new
      Timesheet.create(
        :username => "egold",
        :date => "2015/3/10",
        :hours => "2",
        :project_type => "non-billable",
        :client => ""
      )
      expect(@timesheet.get_timesheet("2")[0]).to eq(nil)
    end
  end
end