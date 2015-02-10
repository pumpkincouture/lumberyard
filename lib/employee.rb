require 'data_mapper'

module LumberYard
  class Employee
    include DataMapper::Resource

    attr_reader :first_name, :last_name, :username, :employee_type

    property :id, Serial
    property :first_name, String
    property :last_name, String
    property :username, String
    property :employee_type, String

    validates_with_method :first_name, :method => :valid_name_attributes?
    validates_with_method :last_name, :method => :valid_name_attributes?
    validates_with_method :username, :method => :valid_username?
    validates_with_method :employee_type, :method => :valid_employee_type?

    def create_employee(attributes)
      Employee.create(
        :first_name => attributes.fetch(:first_name),
        :last_name => attributes.fetch(:last_name),
        :username => attributes.fetch(:username),
        :employee_type => attributes.fetch(:employee_type)
        )
    end

    def get_employee(params)
      search_for_employee(params)
    end

    def non_admin?(params)
      employee_non_admin?(Employee.first(:username => params.downcase))
    end

    def admin?(params)
      employee_admin?(Employee.first(:username => params.downcase))
    end

    def employee_exists?(params)
      employee_in_database?(params)
    end

    private

    def valid_employee_type?
      ['admin', 'non-admin'].include?(employee_type)
    end

    def valid_employee_fields?
      valid_name_attributes? && valid_username?
    end

    def valid_name_attributes?
      !last_name.nil? && !last_name.empty?
       !first_name.nil? && !first_name.empty?
    end

    def valid_username?
      !username.nil? && !username.empty?
    end

    def employee_admin?(employee)
      ["admin"].include?(employee.employee_type)
    end

    def employee_non_admin?(employee)
      ["non-admin"].include?(employee.employee_type)
    end

    def employee_in_database?(employee)
      !Employee.all(:username => employee.downcase).empty?
    end

    def search_for_employee(employee)
      Employee.first(:username => employee.downcase)
    end
  end
end