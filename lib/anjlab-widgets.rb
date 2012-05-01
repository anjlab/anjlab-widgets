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
        self.parse_date! date_string
      rescue
        nil
      end
    end

    def self.format_date date
      return '' if date.nil?
      date.strftime self.date_format
    end

    def self.parse_time! time_string
      return nil if date_string.blank?
      now = Time.now
      parts = time_string.split(':')
      Time.local(now.year, now.month, day, parts[0], parts[1])
    end

    def self.parse_time time_string
      begin
        self.parse_time! date_string
      rescue
        nil
      end
    end

    def self.parse_datetime! date_string, time_string
      date = parse_date date_string
      time = parse_time time_string
      Time.local(date.year, date.month, date.day, time.hour, time.min)
    end

    def self.parse_datetime date_string, time_string
      begin
        self.parse_datetime! date_string, time_string
      rescue
        nil
      end
    end

    def self.format_time time
      nil if time.nil?
      time.strftime "%H:%M"
    end
  end
end
