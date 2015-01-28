class TimeSheet
  require 'date'
  require 'data_mapper'

  include DataMapper::Resource

  property :id, Serial
  property :username, String
  property :date, String
  property :hours, String
  property :project_type, String

  validates_with_method :username, :all_fields_present?
  validates_with_method :date, :valid_date?
  validates_with_method :hours, :all_fields_present?
  validates_with_method :project_type, :all_fields_present?
  validates_with_method :project_type, :project_type_valid?

  private

  def all_fields_present?
    [@username, @date, @hours, @project_type].all? {|field| present?(field)}
  end

  def present?(field)
    !field.nil? && !field.empty?
  end

  def project_type_valid_and_present?
    all_fields_present && project_type_valid?
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