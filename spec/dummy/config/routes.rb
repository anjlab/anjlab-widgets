Dummy::Application.routes.draw do

  match '/all' => 'widgets#all'
  match '/datepicker' => 'widgets#datepicker'
  match '/timepicker' => 'widgets#timepicker'
  match '/simple_form' => 'widgets#simple_form'

end
