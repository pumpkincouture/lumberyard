class TimeSheet
  require 'date'

  def initialize(attributes)
    @attributes = attributes
  end

  def valid?
    all_fields_present? && project_type_valid? && valid_string_format?(get_date) && past_date?(get_date)
  end

  private

  def all_fields_present?
    [:username, :year, :month, :day, :hours, :project_type].all? {|field| present?(field)}
  end

  def present?(field)
    !@attributes[field].nil? && !@attributes[field].empty?
  end

  def project_type_valid?
    ['billable', 'non-billable', 'PTO'].include?(@attributes[:project_type].downcase)
  end

  def valid_string_format?(date_string)
    y, m, d = date_string.split '/'
    Date.valid_date? y.to_i, m.to_i, d.to_i
  end

  def past_date?(date_string)
    Date.parse(date_string) < Date.today
  end

  def get_date
    "#{@attributes[:year]}" + '/' + "#{@attributes[:month]}" + '/' + "#{@attributes[:day]}"
  end
end