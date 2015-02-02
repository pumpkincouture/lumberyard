require 'data_mapper'
require_relative 'lumberyard_constants.rb'

class Employee
  include DataMapper::Resource
  include LumberYardConstants

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

  private

  def valid_employee_type?
    EMPLOYEE_TYPES.include?(employee_type)
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
end