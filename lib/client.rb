class Client
  def initialize(attributes)
    @attributes = attributes
  end

  def valid?
    present?(:name) && present?(:type)
  end

  private

  def present?(field)
    !@attributes[field].nil? && !@attributes[field].empty?
  end
end