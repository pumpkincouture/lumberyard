require 'rspec'
require 'timesheet'

def new_timesheet(attributes = {})
    TimeSheet.new({
      username:"solak",
      year:"2015",
      month:"1",
      day:"23",
      hours:"6",
      project_type: "Billable"}.merge(attributes)
    )
  end

describe TimeSheet do

  context "timesheet attributes" do
    it "requires all fields to be valid" do
      timesheet = new_timesheet
      expect(timesheet.valid?).to eq(true)
    end

    it "missing project_type is not valid" do
      timesheet = new_timesheet({project_type: ""})
      expect(timesheet.valid?).to eq(false)
    end

    it "missing username is not valid" do
      timesheet = new_timesheet({username: nil})
      expect(timesheet.valid?).to eq(false)
    end

    it "missing year is not valid" do
      timesheet = new_timesheet({year:nil})
      expect(timesheet.valid?).to eq(false)
    end

    it "missing month is not valid" do
      timesheet = new_timesheet({month:nil})
      expect(timesheet.valid?).to eq(false)
    end

    it "missing day is not valid" do
      timesheet = new_timesheet({day:nil})
      expect(timesheet.valid?).to eq(false)
    end

    it "missing hours is not valid" do
      timesheet = new_timesheet({hours:""})
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "project_types" do
    it "type can only be PTO, Billable, or NonBillable" do
      timesheet = new_timesheet({project_type: "whatever"})
      expect(timesheet.valid?).to eq(false)
    end
  end

  context "timesheet date" do
    it "required date cannot be in the future" do
      timesheet = new_timesheet({year: "2015", month: "3", day: "25"})
      expect(timesheet.valid?).to eq(false)
    end

    it "required date must be in a valid format" do
      timesheet = new_timesheet({year: "13", day: "2015", month: "9"})
      expect(timesheet.valid?).to eq(false)
    end
  end
end