class Extender
	constructor: (@parent, @hover = false, @count = 6) ->
		@open = false
		@init()

	init: ->
		@getElements()
		@maxHeight = @elements.list.height()
		@setup()
		@attachEvents()

	getElements: ->
		@elements =
			parent: @parent
			list: @parent.find '> ul'
			li: @parent.find '> ul > li'
			plus: @parent.find '.plus'
			link: @parent.find '.plus a'

	setup: ->
		@initHeight = @elements.li.height() * @count
		@elements.list.height @initHeight

	attachEvents: ->
		if @hover
			@elements.list.on 'mouseenter', @openUp
			@elements.parent.on 'mouseleave', @close
		@elements.link.on 'click', @toggleOpen

	openUp: =>
		@open = true
		@elements.link.text '-'
		@elements.list.animate height: @maxHeight, 500

	close: =>
		@open = false
		@elements.link.text '+'
		@elements.list.animate height: @initHeight, 500

	toggleOpen: (e) =>
		e.preventDefault() if e
		if @open
			@close()
		else
			@openUp()