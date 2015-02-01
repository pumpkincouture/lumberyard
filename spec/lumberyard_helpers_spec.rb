require 'rspec'

describe LumberYardHelpers do
  include LumberYardHelpers

  describe '#admin?' do
    it "finds an admin employee" do
      expect(admin?('dlockhart')).to eq(true)
    end
  end

  describe '#non_admin?' do
    it "finds a non_admin employee" do
      expect(non_admin?('dsmith')).to eq(false)
    end
  end

  describe '#employee_exists?' do
    it "returns false if employee not found" do
      expect(employee_exists?('radams')).to eq(false)
    end

    it "returns true if employee is found" do
      expect(employee_exists?('dlockhart')). to eq(true)
    end
  end

  describe '#find_employee' do
    it "returns employee object" do
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
      expect(get_all_clients.first.name).to eq("Praxair")
    end
  end

  describe '#get_timesheet' do
    it "returns this month's timesheet for logged in employee" do
      expect(get_timesheet.empty?).to eq(true)
    end
  end
end