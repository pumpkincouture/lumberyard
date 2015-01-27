require 'rspec'
require 'employee'

describe Employee do

  def new_employee(attributes = {})
    Employee.new(
      {first_name: "Mike",
        last_name: "Jansen",
        username: "mjansen",
        employee_type: "admin"
      }.merge(attributes)
    )
  end

  context "employee_type" do
    it 'admin is valid' do
      employee = new_employee
      expect(employee.valid?).to eq(true)
    end

    it 'non-admin is valid' do
      employee = new_employee({employee_type: "non-admin"})
      expect(employee.valid?).to eq(true)
    end

    it 'anything else is invalid' do
      employee = new_employee({employee_type: "something"})
      expect(employee.valid?).to eq(false)
    end
  end

  context "presence of attributes" do
    it "all input fields required" do
      employee = new_employee()
      expect(employee.valid?).to eq(true)
    end

    it "missing input fields are invalid" do
      employee = new_employee({username: nil})
      expect(employee.valid?).to eq(false)
    end
  end
end