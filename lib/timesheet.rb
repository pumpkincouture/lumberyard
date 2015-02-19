require 'data_mapper'
require 'model_citizen'

module LumberYard
  class Timesheet
    include DataMapper::Resource

    attr_reader :username, :date, :hours, :project_type, :client

    property :id, Serial
    property :username, String
    property :date, String
    property :hours, String
    property :project_type, String
    property :client, String, :default => "NA"

    validates_with_method :username, :valid_attribute?
    validates_with_method :date, :valid_date?
    validates_with_method :hours, :valid_attribute?
    validates_with_method :project_type, :valid_attribute?
    validates_with_method :project_type, :valid_attribute?
    validates_with_method :client, :client_valid?

    def model_citizen
      model_citizen = ModelCitizen::Validations.new
    end

    def create_timesheet(attributes)
      Timesheet.create(
        :username => attributes.fetch(:username),
        :date => attributes.fetch(:date),
        :hours => attributes.fetch(:hours),
        :project_type => attributes.fetch(:project_type),
        :client => attributes.fetch(:client)
        )
    end

    def get_this_month
      model_citizen.get_this_month
    end

    def get_timesheet(month)
       get_timesheet_from_database(month)
    end

    def get_timesheet_for_employee(month, employee)
      get_timesheet_from_database_with_employee(month, employee)
    end

    private

    def valid_attribute?
      model_citizen.not_nil_or_empty?([username, date, hours, project_type]) &&
      model_citizen.value_included?('billable', 'Billable', 'non-billable', 'Non-billable', 'pto', 'PTO', project_type)
    end

    def client_valid?
      unless client_field_still_na? || client_field_still_invalid? || project_not_billable?
        return true
      end
      false
    end

    def client_field_still_na?
      model_citizen.value_included?('billable', 'Billable', project_type) && client == "NA"
    end

    def project_not_billable?
      !model_citizen.value_included?('billable', 'Billable', project_type) && client != ""
    end

    def client_field_still_invalid?
      model_citizen.value_included?('billable', 'Billable', project_type) && !model_citizen.not_nil_or_empty?([client])
    end

    def valid_date?
      model_citizen.valid_date?(date)
    end

    def get_timesheet_from_database_with_employee(month, employee)
      Timesheet.find_all{|entry| y, m, d = entry.date.split '/'
        m == month && entry.username == employee
      }
    end

    def get_timesheet_from_database(month)
      Timesheet.find_all{|entry| y, m, d = entry.date.split '/'
        m == month
      }
    end
  end
end