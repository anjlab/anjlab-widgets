Locales = 
  en:
    dates:
      format: 'mm/dd/yyyy'
      weekStart: 0
      days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
      daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
      daysMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
      months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  es:
    dates:
      format: 'yyyy-mm-dd'
      weekStart: 0
      days: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
      daysShort: ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"]
      daysMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"]
      months: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
      monthsShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
  ru: 
    dates:
      format: 'dd.mm.yyyy'
      weekStart: 1
      days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
      daysShort: ["Вск", "Пон", "Втр", "Срд", "Чтв", "Птн", "Суб", "Вск"]
      daysMin: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
      months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
      monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]

DateTools =
  modes: [
    {
      clsName: 'days'
      navFnc: 'Month'
      navStep: 1
    },
    {
      clsName: 'months'
      navFnc: 'FullYear'
      navStep: 1
    },
    {
      clsName: 'years'
      navFnc: 'FullYear'
      navStep: 10
    }
  ]
  isLeapYear: (year) ->
    (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
  
  getDaysInMonth: (year, month) ->
    [31, (if DateTools.isLeapYear(year) then 29 else 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]

  parseFormat: (format) ->
    separator = format.match(/[.\/-].*?/)
    parts = format.split(/\W+/)
    if !separator || !parts || parts.length == 0
      throw new Error("Invalid date format.")  
    
    {
      separator: separator
      parts: parts
    }

  parseDate: (date, format) ->
    parts = date.split(format.separator)

    if parts.length != format.parts.length
      null
    else
      for i in [0...format.parts.length]
        val = parseInt(parts[i], 10) || 1;
        switch format.parts[i]
          when 'dd', 'd'
            d = val
          when 'mm', 'm'
            m = val - 1
          when 'yy'
            y = 2000 + val
          when 'yyyy'
            y = val
      new Date(y, m, d)
  
  formatDate: (date, format) ->
    return "" if date == null
    val = {
      d: date.getDate()
      m: date.getMonth() + 1
      yy: date.getFullYear().toString().substring(2)
      yyyy: date.getFullYear()
    }
    val.dd = (if val.d < 10 then '0' else '') + val.d
    val.mm = (if val.m < 10 then '0' else '') + val.m
    date = []
    for i in [0...format.parts.length]
      date.push val[format.parts[i]]
    date.join format.separator

  today: ->
    now = new Date()
    new Date(now.getFullYear(), now.getMonth(), now.getDate(),0,0,0,0)

  getLocale: () ->
    $('html').prop('lang') || 'en'

  headTemplate: '<thead>'+
            '<tr>'+
              '<th class="prev"><i class="icon-arrow-left"/></th>'+
              '<th colspan="5" class="switch"></th>'+
              '<th class="next"><i class="icon-arrow-right"/></th>'+
            '</tr>'+
          '</thead>'

  contTemplate: '<tbody><tr><td colspan="7"></td></tr></tbody>'

DateTools.template = '<div class="datepicker dropdown-menu">'+
            '<div class="datepicker-days">'+
              '<table class=" table-condensed">'+
                DateTools.headTemplate+
                '<tbody></tbody>'+
              '</table>'+
            '</div>'+
            '<div class="datepicker-months">'+
              '<table class="table-condensed">'+
                DateTools.headTemplate+
                DateTools.contTemplate+
              '</table>'+
            '</div>'+
            '<div class="datepicker-years">'+
              '<table class="table-condensed">'+
                DateTools.headTemplate+
                DateTools.contTemplate+
              '</table>'+
            '</div>'+
          '</div>'

class NativeRailsDatepicker
  constructor: (element, options)->
    @element = $(element)
    @rails   = options.rails ? @element.data('rails') ? false

    @element.on {
      keyup: $.proxy(@update, this)
      change: $.proxy(@update, this)
    }

  update: ->
    @date = DateTools.parseDate @element.val(), {
      separator: '-'
      parts: ["yyyy", "mm", "dd"]
    }

    @updateRails()

  updateRails: ->
    return if !@rails

    parent = @element.closest('.controls, form, div')
    if @date == null
      parent.find('.js-aw-1i, .js-aw-2i, .js-aw-3i').val('')
    else
      parent.find('.js-aw-1i').val(@date.getFullYear())
      parent.find('.js-aw-2i').val(@date.getMonth() + 1)
      parent.find('.js-aw-3i').val(@date.getDate())      


class Datepicker extends NativeRailsDatepicker

  constructor: (element, options)->
    super(element, options)
    @locale  = options.locale || @element.data('date-locale') || DateTools.getLocale() 
    @format  = DateTools.parseFormat(options.format || @element.data('date-format') || Locales[@locale].dates.format);
    @allowBlank = options.allowBlank ? @element.data('date-allow-blank') ? true
    @picker  = $(DateTools.template).appendTo('body').on {
      click: $.proxy(@click, this)
      mousedown: $.proxy(@mousedown, this)
    }

    @isInput = @element.is('input');
    @component = if @element.is('.date') then @element.find('.add-on') else false;

    if @isInput
      @element.on {
        focus: $.proxy(@show, this)
        click: $.proxy(@show, this)
        blur: $.proxy(@hide, this)
        keyup: $.proxy(@update, this)
      }
    else
      if @component
        @component.on 'click', $.proxy(@show, this)
      else
        @element.on 'click', $.proxy(@show, this)

    @viewMode = 0;
    @weekStart = options.weekStart || @element.data('date-weekstart') || Locales[@locale].dates.weekStart
    @weekEnd = if this.weekStart == 0 then 6 else @weekStart - 1
    @fillDow()
    @fillMonths()
    @update()
    @showMode()

  show: (e) ->
    @picker.show()
    @height = if @component then @component.outerHeight() else @element.outerHeight()
    @place()
    $(window).on('resize', $.proxy(@place, this))
    if e
      e.stopPropagation()
      e.preventDefault()
    
    $(document).on('mousedown', $.proxy(@hide, this)) if !@isInput
    
    @element.trigger
      type: 'show'
      date: @date

  hide: ->
    @picker.hide()
    $(window).off 'resize', @place
    @viewMode = 0
    @showMode()
    $(document).off('mousedown', @hide) if !@isInput

    @setValue()
    @element.trigger
      type: 'hide'
      date: @date

  setValue: ->
    formated = DateTools.formatDate(@date, @format)
    if !@isInput
      if @component
        @element.find('input').prop('value', formated)
      @element.data('date', formated)
    else
      @element.prop('value', formated)

  place: ->
    offset = if @component then @component.offset() else @element.offset()
    @picker.css
      top: offset.top + @height
      left: offset.left

  update: ->
    @date = DateTools.parseDate(
      if @isInput then this.element.prop('value') else @element.data('date'),
      @format
    )

    if @date == null && !@allowBlank
      @date = DateTools.today()

    if @date != null
      @viewDate = @date
    else
      @viewDate = DateTools.today()
    @fill()

  fillDow: ->
    dowCnt = @weekStart
    html = ['<tr>']
    while dowCnt < @weekStart + 7
      html.push '<th class="dow">'
      html.push Locales[@locale].dates.daysMin[(dowCnt++)%7]
      html.push '</th>'
    html.push '</tr>'

    @picker.find('.datepicker-days thead').append(html.join(''))

  fillMonths: ->
    html = []
    i = 0
    while i < 12
      html.push '<span class="month">'
      html.push Locales[@locale].dates.monthsShort[i++]
      html.push '</span>'
    
    @picker.find('.datepicker-months td').append(html.join(''))

  fill: ->
    d = new Date(@viewDate)
    year = d.getFullYear()
    month = d.getMonth()

    @updateRails()
    date = if @date != null then @date else DateTools.today()
    currentDate = if @date != null then @date.valueOf() else 0

    @picker.find('.datepicker-days th:eq(1)').text(Locales[@locale].dates.months[month]+' '+year)
    prevMonth = new Date(year, month-1, 28,0,0,0,0)
    day = DateTools.getDaysInMonth(prevMonth.getFullYear(), prevMonth.getMonth())
    prevMonth.setDate(day)
    prevMonth.setDate(day - (prevMonth.getDay() - @weekStart + 7)%7)
    nextMonth = new Date(prevMonth);
    nextMonth.setDate(nextMonth.getDate() + 42)
    nextMonth = nextMonth.valueOf()
    html = [];

    while prevMonth.valueOf() < nextMonth
      html.push '<tr>' if prevMonth.getDay() == @weekStart
        
      clsName = '';
      if prevMonth.getMonth() < month
        clsName += ' old'   
      else if prevMonth.getMonth() > month
        clsName += ' new'
      
      if prevMonth.valueOf() == currentDate
        clsName += ' active'
      
      html.push "<td class='day#{clsName}'>#{prevMonth.getDate()}</td>"
      html.push '</tr>' if prevMonth.getDay() == @weekEnd
        
      prevMonth.setDate(prevMonth.getDate()+1)
    

    @picker.find('.datepicker-days tbody').empty().append(html.join(''))
    currentYear = date.getFullYear()
    
    months = @picker.find('.datepicker-months').find('th:eq(1)').text(year).end().find('span').removeClass('active')
    months.eq(date.getMonth()).addClass('active') if currentYear == year

    html = '';
    year = parseInt(year/10, 10) * 10
    yearCont = @picker.find('.datepicker-years').find('th:eq(1)').text(year + '-' + (year + 9)).end().find('td')
    year -= 1;
    for i in [-1...11]
      html += '<span class="year'+(i == -1 || if i == 10 then ' old' else '')+(if currentYear == year then ' active' else '')+'">'+year+'</span>'
      year += 1;
    yearCont.html html

  click: (e)=>
    e.stopPropagation()
    e.preventDefault()
    target = $(e.target).closest('span, td, th')
    if target.length == 1
      switch target[0].nodeName.toLowerCase()
        when 'th'
          switch target[0].className
            when 'switch'
              @showMode(1)
            when 'prev', 'next'
              @viewDate['set'+DateTools.modes[this.viewMode].navFnc].call(
                @viewDate,
                @viewDate['get'+DateTools.modes[this.viewMode].navFnc].call(@viewDate) + 
                DateTools.modes[this.viewMode].navStep * (if target[0].className == 'prev' then -1 else 1))
              @fill()
        when 'span'
          if target.is('.month')
            month = target.parent().find('span').index(target)
            @viewDate.setMonth(month)
          else
            year = parseInt(target.text(), 10) || 0
            @viewDate.setFullYear(year)
          @showMode(-1)
          @fill()
        when 'td'
          if target.is('.day')
            day = parseInt(target.text(), 10) || 1
            month = @viewDate.getMonth()
            if target.is('.old')
              month -= 1
            else if target.is('.new')
              month += 1
            
            year = @viewDate.getFullYear()
            @date = new Date(year, month, day,0,0,0,0);
            @viewDate = new Date(year, month, day,0,0,0,0);
            @fill()
            @setValue()
            @element.trigger {
              type: 'changeDate'
              date: @date
            }
            @hide()

  mousedown: (e)->
    e.stopPropagation()
    e.preventDefault()

  showMode: (dir)->
    @viewMode = Math.max(0, Math.min(2, this.viewMode + dir)) if dir
    @picker.find('>div').hide().filter('.datepicker-'+DateTools.modes[this.viewMode].clsName).show()

nativePicker = false

convertToNative = ($input, options)->
  value = $input.attr('value')
  $input.prop("type", "date")
  if value && value.length > 0
    locale = options.locale || $input.data('date-locale') || DateTools.getLocale()
    format  = DateTools.parseFormat(options.format || $input.data('date-format') || Locales[locale].dates.format);
    date = DateTools.parseDate(value, format)
    value = DateTools.formatDate(date, {
      separator: '-'
      parts: ["yyyy", "mm", "dd"]
    })
    $input.prop('value', value)
  

$.fn.datepicker = (option) ->
  @each ->
    $this = $(this)
    data = $this.data('datepicker')
    options = typeof option == 'object' && option
    if !data
      if nativePicker
        convertToNative($this, options)
        $this.data('datepicker', (data = new NativeRailsDatepicker(this, $.extend({}, $.fn.timepicker.defaults,options))))
      else
        $this.data('datepicker', (data = new Datepicker(this, $.extend({}, $.fn.datepicker.defaults,options))))
    data[option]() if typeof option == 'string'

$.fn.datepicker.defaults = { }
$.fn.datepicker.Constructor = Datepicker

$ ->
  input = document.createElement("input")
  input.setAttribute("type", "date")
  # Chrome has ugly native date picker so we show ours
  # nativePicker = input.type == "date"
  nativePicker = input.type == "date" && !navigator.userAgent.match(/chrome/i)

  $("input[data-widget=datepicker]").datepicker()
  $(document).on 'focus.data-api click.data-api touchstart.data-api', 'input[data-widget=datepicker]', (e)-> $(e.target).datepicker()
