TimeTools =

  template: "<div class='timepicker dropdown-menu'><div class='times'></div></div>"

class Timepicker

  constructor: (element, options)->
    @element = $(element)
    @picker  = $(TimeTools.template).appendTo('body').on({
      click: $.proxy(@click, this)
      mousedown: $.proxy(@mousedown, this)
    }, "a")

    @element.on {
      focus: $.proxy(@show, this)
      blur: $.proxy(@hide, this)
      keyup: $.proxy(@update, this)  
    }

    @step    = options.step || @element.data('date-time-step') || 30
    @minTime = options.minTime || @element.data('date-time-min') || 9 * 60
    @maxTime = options.maxTime || @element.data('date-time-max') || 20 * 60

    @fillTimes()
    @update()
    @scrollPlaced = false

  initialScroll: ->
    return if @scrollPlaced
    time = @picker.find('.active')
    if time.length > 0
      @picker.find('.times').scrollTop(time.position().top - time.height())
    @scrollPlaced = true

  click: (e)->
    e.stopPropagation()
    e.preventDefault()
    target = $(e.target)

    if target.is 'a' 
      @time = target.data('time')
      @setValue()
      @update()
      @element.trigger {
        type: 'changeDate'
        date: @time
      }

  mousedown: (e)->
    e.stopPropagation()
    e.preventDefault()

  update: ->
    @time = this.element.val()
    @picker.find('a.active').removeClass('active')
    @picker.find("a[data-time='#{@time}']").addClass('active')

  setValue: ->
    @element.prop('value', @time)

  fillTimes: ->
    timeCnt = 0
    html = []
    while timeCnt < 24 * 60
      mm = timeCnt % 60
      hh = Math.floor(timeCnt / 60)
      mm = (if mm < 10 then '0' else '') + mm
      hh = (if hh < 10 then '0' else '') + hh
      time = "#{hh}:#{mm}"
      html.push "<a href='#' data-time='#{time}'"
      html.push " class='night'" if timeCnt <= @minTime || timeCnt >= @maxTime
      html.push ">"
      html.push time
      html.push "</a>"
      timeCnt += @step

    @picker.find('.times').append(html.join(''))

  show: (e) ->
    @picker.show()
    @height = @element.outerHeight()
    @place()
    @initialScroll()
    $(window).on('resize', $.proxy(@place, this))
    if e
      e.stopPropagation()
      e.preventDefault()
    
    @element.trigger {
      type: 'show'
      date: @time
    }

  place: ->
    offset = @element.offset()
    @picker.css {
      top: offset.top + @height
      left: offset.left
    }

  hide: ->
    @picker.hide()
    $(window).off 'resize', @place

    @setValue()
    @element.trigger {
      type: 'hide'
      date: @time
    }

nativePicker = false

$.fn.timepicker = (option) ->
  @each ->
    $this = $(this)
    if nativePicker
      $this.prop("type", "time")
    else
      data = $this.data('timepicker')
      options = typeof option == 'object' && option
      if !data
        $this.data('timepicker', (data = new Timepicker(this, $.extend({}, $.fn.timepicker.defaults,options))))
      data[option]() if typeof option == 'string'

$.fn.timepicker.defaults = { }
$.fn.timepicker.Constructor = Timepicker

$ ->
  input = document.createElement("input")
  input.setAttribute("type", "time")
  nativePicker = input.type == "time"

  $("input[data-widget=timepicker]").timepicker()


