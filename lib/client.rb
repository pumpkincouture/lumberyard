require 'data_mapper'
require 'model_citizen'

module LumberYard
  class Client
    include DataMapper::Resource

    attr_reader :name, :type

    property :id, Serial
    property :name, String
    property :type, String

    validates_with_method :name, :method => :valid_attribute?
    validates_with_method :type, :method => :valid_attribute?

    def model_citizen
      model_citizen = ModelCitizen::Validations.new
    end

    def find_clients
      find_clients_in_database
    end

   def create_client(attributes)
      Client.create(
        :name => attributes.fetch(:name),
        :type => attributes.fetch(:type)
        )
    end

    private

    def valid_attribute?
      model_citizen.not_nil_or_empty?([name, type])
    end

    def find_clients_in_database
      Client.all
    end
  end
end