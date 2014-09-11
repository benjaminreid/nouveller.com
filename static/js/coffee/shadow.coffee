class Shadow
	constructor: ->
		@init()

	init: ->
		@getElements()
		@setup()
		@attachEvents()

	getElements: ->
		@elements =
			header: $ '.page-header'
			document: $(document)

	attachEvents: ->
		@elements.document.on 'scroll', @checkScroll

	setup: ->
		@cutoff = 60
		@cutoff = 420 if not $('html').hasClass 'closed'

	checkScroll: =>
		if @elements.document.scrollTop() > @cutoff
			@elements.header.addClass 'header-shadow'
		else
			@elements.header.removeClass 'header-shadow'