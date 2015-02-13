require 'data_mapper'
require 'model_citizen'

module LumberYard
  class Employee
    include DataMapper::Resource

    attr_reader :first_name, :last_name, :username, :employee_type

    property :id, Serial
    property :first_name, String
    property :last_name, String
    property :username, String
    property :employee_type, String

    validates_with_method :first_name, :method => :valid_attribute?
    validates_with_method :last_name, :method => :valid_attribute?
    validates_with_method :username, :method => :valid_attribute?
    validates_with_method :employee_type, :method => :valid_attribute?

    def create_employee(attributes)
      Employee.create(
        :first_name => attributes.fetch(:first_name),
        :last_name => attributes.fetch(:last_name),
        :username => attributes.fetch(:username),
        :employee_type => attributes.fetch(:employee_type)
        )
    end

    def model_citizen
      model_citizen = ModelCitizen::Validations.new
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

    def valid_attribute?
      model_citizen.not_nil_or_empty?([last_name, first_name, username]) &&
      model_citizen.value_included?('admin', 'non-admin', employee_type)
    end

    def employee_admin?(employee)
      model_citizen.value_included?('admin', employee.employee_type)
    end

    def employee_non_admin?(employee)
      model_citizen.value_included?('non-admin', employee.employee_type)
    end

    def employee_in_database?(employee)
      !Employee.all(:username => employee.downcase).empty?
    end

    def search_for_employee(employee)
      Employee.first(:username => employee.downcase)
    end
  end
end