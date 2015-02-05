require 'data_mapper'

module LumberYard
  class Client

    include DataMapper::Resource

    attr_reader :name, :type

    property :id, Serial
    property :name, String
    property :type, String

    validates_with_method :name, :method => :valid_name?
    validates_with_method :type, :method => :valid_type?

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

    def valid_name?
      !name.nil? && !name.empty?
    end

    def valid_type?
      !type.nil? && !type.empty?
    end

    def get_all_clients_from_database
      Client.all
    end
  end
end