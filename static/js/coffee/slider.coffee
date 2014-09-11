class Slider
  constructor: (@container, @options = {}, @cb = false) ->
    if @container.length 
      @setupOptions()
      @init()

  init: ->
    # if 1 or more elements need to appear on the slider
    @createChildren() if @options.span > 1
    @getElements()
    @setup()
    @attachEvents()

  setupOptions: ->
    @options.infinite = false if not @options.infinite
    @options.speed = 500 if not @options.speed
    @options.span = 1 if not @options.span
    @options.width = null if not @options.width
    @options.animation = 'slide' if not @options.animation

    ease = 'linear'
    if typeof $.easing.easeOutQuad == 'function'
    	ease = if @options.ease then @options.ease else ease
    @options.ease = ease

  getElements: ->
    @elements =
      container: @container
      list: @container.find '.slider'
      slides: @container.find '.slider > li'
      nav:
        left: @container.find '.slider-left'
        right: @container.find '.slider-right'

  setup: ->
    @disabled = false
    @isAnimating = false

    # width of the container
    @options.width = @elements.container.width() if not @options.width

    # initial position
    @pos = 0

    # max amount of slides
    @max = (@elements.slides.length) - 1

    @disableNav() if @max <= 0

    # position all slides outside of the container, except the first
    slides = @elements.list.find '> li:not(:first-child)'
    slides.css 'left': @options.width

    # set current nav item
    @elements.current = $ @elements.slides[0]

    # check the navigation
    @checkNav()

  createChildren: ->
    max = @container.find('.slider li').length
    per = @options.span
    pos = 0
    html = ''

    # number of slides needed
    slides = Math.ceil(max / per)

    createSlide = () =>
      # create a new list item with an inner list
      html += '<li><ul>'
      # get the list elements for the next list
      listInner = @container.find('.slider li').slice(pos, pos+per)
      
      listInner.each (i, el) ->
        innerHtml = $(el).html()
        html += "<li>#{innerHtml}</li>"

      # close the list and move the pointer on
      pos += per
      html += '</ul></li>'

    createSlide i for i in [0...slides]
    @container.find('.slider').html html

  attachEvents: ->
    self = @

    @elements.nav.left.on 'click', @previous
    @elements.nav.right.on 'click', @next

    # if support for hammer touch events
    if typeof jQuery.fn.hammer is 'function'

      @elements.container.hammer().bind 'swipe', (e) ->
        if e.direction is 'left'
          self.next(e)
        else
          self.previous(e)


  previous: (e) =>
    e.preventDefault()
    return if @isAnimating or @disabled

    if @options.infinite
      if @pos is 0
        @pos = (@max + 1)
    
    if @pos > 0
      @pos -= 1
      @move 'right'

  next: (e) =>
    e.preventDefault()
    return if @isAnimating or @disabled

    if @options.infinite
      if @pos is @max
        @pos = -1

    if @pos < @max
      @pos += 1
      @move 'left'

  move: (direction) ->
    self      = @
    nextEl    = $ @elements.slides[@pos]
    currentEl = @elements.current
    width     = @options.width
    speed     = @options.speed
    @isAnimating = true

    # fade animation
    if @options.animation is 'fade'
      currentEl.animate opacity: 0, speed, ->
        currentEl.css left: "-#{width}px"
      nextEl.css opacity: 0, left: 0
      nextEl.animate opacity: 1, speed, -> self.isAnimating = false

    # fade animation
    else
      if direction is 'left'
        currentEl.animate left: "-#{width}px", speed, -> self.isAnimating = false
        nextEl.css left: width
        nextEl.animate left: 0, speed

      if direction is 'right'
        currentEl.animate left: "#{width}", speed, -> self.isAnimating = false
        nextEl.css left: "-#{width}px"
        nextEl.animate left: 0, speed

    @elements.current = nextEl

    @cb @pos if @cb

    @checkNav()

  checkNav: ->
    return if @options.infinite

    if @pos is 0
      @disable @elements.nav.left

    if @pos > 0
      @enable @elements.nav.left

    if @pos is @max
      @disable @elements.nav.right

    if @pos < @max
      @enable @elements.nav.right

  disable: (el) ->
    el.addClass 'slide-nav-end'

  enable: (el) ->
    el.removeClass 'slide-nav-end'

  disableNav: ->
    @disable @elements.nav.left
    @disable @elements.nav.right
    @disabled = true