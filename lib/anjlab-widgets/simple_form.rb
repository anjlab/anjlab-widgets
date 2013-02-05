module Anjlab
  module Widgets
    class DateTimeInput < SimpleForm::Inputs::DateTimeInput

      def label_target
        attribute_name
      end

      def input
        time = options[:value] || @builder.object[attribute_name]

        html = ''

        allow_blank = !options[:required]

        date_data = {
          "data-widget" => "datepicker",
          "data-rails" => true,
          "data-date-allow-blank" => allow_blank,
          :value => Widgets::format_date(time),
          :required => input_html_options[:required],
          :class => "#{input_html_options[:date_class] || 'input-small'}"
        }

        time_data = {
          "data-widget" => "timepicker",
          "data-rails" => true,
          :value => Widgets::format_time(time),
          :required => input_html_options[:required],
          :class => "#{input_html_options[:time_class] || 'input-small'}"  
        }

        default_parts = [''] * 5

        case input_type
        when :datetime, :anjlab_datetime
          html << @builder.text_field(attribute_name, date_data)
          html << '&nbsp;&nbsp;&nbsp;'
          html << @builder.text_field(attribute_name, time_data)
        when :date, :anjlab_date
          html << @builder.text_field(attribute_name, date_data)
        when :time, :anjlab_time
          now = Time.now
          default_parts = [now.year, now.month, now.day, '', '']
          html << @builder.text_field(attribute_name, time_data)
        end

        values = time ? [time.year, time.month, time.day, time.hour, time.min] : default_parts
        values.each_with_index do |v, index|
          i = index + 1
          html << @builder.hidden_field("#{attribute_name}(#{i}i)", value: v,  class: "js-aw-#{i}i")
        end
        html
      end
    end
  end
end