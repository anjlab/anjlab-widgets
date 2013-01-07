# Anjlab::Widgets

Bootstrap date and time pickers for rails (ready for rails 4).

Note: `simple_form` gem is supported.

Currently `en` and `ru` locales supported.

## Installation

Add this line to your application's Gemfile:

    gem 'anjlab-widgets'

And then execute:

    $ bundle

## Usage

Add date and time pickers to your application.js

```javascript
//= require anjlab/datepicker
//= require anjlab/timepicker
```

Add date and time pickers to your application.css.scss

```scss
@import 'twitter/bootstrap';

@import 'anjlab/datepicker';
@import 'anjlab/timepicker';
```

### With FormBuilder

```erb
  <%= f.text_field :updated_at, value: Anjlab::Widgets.format_date(f.object.updated_at), "data-widget"=>"datepicker" %>
  <%= f.text_field :updated_at, value: Anjlab::Widgets.format_time(f.object.updated_at), "data-widget"=>"timepicker" %>
```

### With simple_form!

You have two options here:

Overwrite standart :date, :datetime and :time inputs:

```ruby
# config/initializers/simple_form.rb
SimpleForm.setup do |config|
  Anjlab::Widgets.simple_form as_default: true
  #...
end
```
In your forms:

```erb
  <%= f.input :created_at # :datetime %>
  <%= f.input :created_at, as: :date %>
  <%= f.input :created_at, as: :time %>
```

Or use prefixed input types:

```ruby
# config/initializers/simple_form.rb
SimpleForm.setup do |config|
  Anjlab::Widgets.simple_form
  #...
end
```

In your forms:

```erb
  <%= f.input :created_at, as: :anjlab_datetime %>
  <%= f.input :created_at, as: :anjlab_date %>
  <%= f.input :created_at, as: :anjlab_time %>
```

## Screen shots

![date picker](https://raw.github.com/anjlab/anjlab-widgets/master/date_pic.png)

![time picker](https://raw.github.com/anjlab/anjlab-widgets/master/time_pic.png)

![native date picker](https://raw.github.com/anjlab/anjlab-widgets/master/native_date_pic.png)

![native time picker](https://raw.github.com/anjlab/anjlab-widgets/master/native_time_pic.png)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
