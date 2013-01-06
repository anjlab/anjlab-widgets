module Anjlab
  module Widgets
    class DateTimeInput < SimpleForm::Inputs::DateTimeInput

      def label_target
        attribute_name
      end

      def input
        time = options[:value] || @builder.object[attribute_name] || Time.now

        formated_time = Widgets::format_time(time)
        formated_date = Widgets::format_date(time)

        date_class = "#{input_html_options[:date_class] || 'input-small'}"
        time_class = "#{input_html_options[:time_class] || 'input-small'}"

        html = ''

        case input_type
        when :datetime, :anjlab_datetime
          html << @builder.text_field(attribute_name, value: formated_date, class: date_class, "data-widget" => "railsdatepicker")
          html << '&nbsp;&nbsp;&nbsp;'
          html << @builder.text_field(attribute_name, value: formated_time, class: time_class, "data-widget" => "railstimepicker")      
        when :date, :anjlab_date
          html << @builder.text_field(attribute_name, value: formated_date, class: date_class, "data-widget" => "railsdatepicker")
        when :time, :anjlab_time
          html << @builder.text_field(attribute_name, value: formated_time, class: time_class, "data-widget" => "railstimepicker")
        end

        html << @builder.hidden_field(attribute_name.to_s+'(1i)', value:time.year,  class:'js-aw-year')
        html << @builder.hidden_field(attribute_name.to_s+'(2i)', value:time.month, class:'js-aw-month')
        html << @builder.hidden_field(attribute_name.to_s+'(3i)', value:time.day,   class:'js-aw-day')
        html << @builder.hidden_field(attribute_name.to_s+'(4i)', value:time.hour,  class:'js-aw-hour')
        html << @builder.hidden_field(attribute_name.to_s+'(5i)', value:time.min,   class:'js-aw-min')
        html
      end
    end
  end
end