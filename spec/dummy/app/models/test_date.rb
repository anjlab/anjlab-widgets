class TestDate < ActiveRecord::Base 
  # Reference for tableless model: http://codetunes.com/2008/tableless-models-in-rails
  attr_accessible :now, :today
  def self.columns() @columns ||= []; end
 
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :now, :datetime
  column :today, :date
end
