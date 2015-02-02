class Client
  require 'data_mapper'

  include DataMapper::Resource

  attr_reader :name, :type

  property :id, Serial
  property :name, String
  property :type, String

  validates_with_method :name, :method => :valid_name?
  validates_with_method :type, :method => :valid_type?

  private

  def valid_name?
    !name.nil? && !name.empty?
  end

  def valid_type?
    !type.nil? && !type.empty?
  end
end