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

    def get_all_clients
      get_all_clients_from_database
    end

   def create_client(attributes)
      Client.create(
        :name => attributes.fetch(:name),
        :type => attributes.fetch(:type)
        )
    end

    private

    def valid_attribute?
      ModelCitizen::Validations.new.not_nil_or_empty?([name, type])
    end

    def get_all_clients_from_database
      Client.all
    end
  end
end