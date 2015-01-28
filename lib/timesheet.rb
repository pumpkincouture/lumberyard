class TimeSheet
  require 'date'
  require 'data_mapper'
  include DataMapper::Resource

  property :id, Serial
  property :username, String
  property :date, String
  property :hours, String
  property :project_type, String
  property :client, String, :default => "NA"

  validates_with_method :username, :all_fields_present?
  validates_with_method :date, :valid_date?, :message => "That is not a valid date."
  validates_with_method :hours, :all_fields_present?
  validates_with_method :project_type, :all_fields_present?
  validates_with_method :project_type, :project_type_valid?
  validates_with_method :client, :client_valid?

  private

  def project_type_valid_and_present?
    all_fields_present && project_type_valid?
  end

  def client_valid?
    return false if client_field_still_na?
    return false if client_field_still_invalid?
    true
  end

  def client_field_still_na?
    need_client_field? && @client == "NA"
  end

  def client_field_still_invalid?
    need_client_field? && !present?(@client)
  end

  def need_client_field?
    project_billable? ? true : false
  end

  def project_billable?
    ['billable', 'Billable'].include?(@project_type)
  end

  def all_fields_present?
    [@username, @date, @hours, @project_type].all? {|field| present?(field)}
  end

  def present?(field)
    !field.nil? && !field.empty?
  end

  def project_type_valid?
    ['billable', 'Billable', 'non-billable', 'Non-billable', 'pto', 'PTO'].include?(@project_type)
  end

  def valid_date?
    valid_string_format? && past_date?
  end

  def valid_string_format?
    y, m, d = @date.split '/'
    return false if y.to_i == 0
    Date.valid_date? y.to_i, m.to_i, d.to_i
  end

  def past_date?
    Date.parse(@date) < Date.today
  end
end