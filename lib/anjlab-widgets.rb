require "anjlab-widgets/version"
require "anjlab-widgets/engine"

module Anjlab
  module Widgets
    def self.date_format 
      case ::I18n.default_locale
      when :ru
        "%d.%m.%Y"
      when :en
        "%m/%d/%Y"
      when :es
        "%d/%m/%Y"
      when :'zh-TW'
        "%Y-%m-%d"
      else
        "%Y-%m-%d"
      end
    end

    def self.parse_date! date_string
      return nil if date_string.blank?
      # native controls date format
      if date_string =~ /\d{4}-[01]\d-[0123]\d/
        ::Date.parse date_string, "%Y-%m-%d"
      else
        ::Date.parse date_string, date_format
      end
    end

    def self.parse_date date_string
      begin
        parse_date! date_string
      rescue
        nil
      end
    end

    def self.format_date date
      return '' if date.nil?
      date.strftime self.date_format
    end

    def self.parse_time! time_string
      return nil if time_string.blank?
      now = Time.now
      parts = time_string.split(':')
      Time.local(now.year, now.month, now.day, parts[0].to_i, parts[1].to_i)
    end

    def self.parse_time time_string
      begin
        self.parse_time! time_string
      rescue
        nil
      end
    end

    def self.parse_datetime! date_string, time_string
      date = parse_date! date_string
      time = parse_time! time_string
      Time.local(date.year, date.month, date.day, time.hour, time.min)
    end

    def self.parse_datetime date_string, time_string
      begin
        parse_datetime! date_string, time_string
      rescue
        nil
      end
    end

    def self.format_time time
      return '' if time.nil?
      time.strftime "%H:%M"
    end

    def self.simple_form options={}
      require 'anjlab-widgets/simple_form'
      SimpleForm::FormBuilder.map_type :anjlab_date, :anjlab_time, :anjlab_datetime, to: DateTimeInput
      if options[:as_default]
        SimpleForm::FormBuilder.map_type :date, :time, :datetime, to: DateTimeInput
      end
    end
  end
end
