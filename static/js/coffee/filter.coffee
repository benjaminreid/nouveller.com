class Filter
	constructor: (@links, @list) ->
		@init()

	init: ->
		@getElements()
		@attachEvents()

	getElements: ->
		@elements =
			links: @links.find 'a'
			list: @list
			items: @list.find '> li'
			none: @list.find '.none'

	attachEvents: ->
		self = @

		@elements.links.on 'click', (e) ->
			e.preventDefault()
			self.filter $(this)

	filter: (el) =>
		# attach current class to clicked nav item
		@elements.links.removeClass 'current'
		el.addClass 'current'

		#the type to filter for
		type = el.data 'filter'

		# hide all the pieces of work
		@elements.items.hide()
		# items that match the selector
		items = @elements.list.find("li[data-type*=#{type}]")
		# show the items
		items.show()

		if items.length > 0
			@elements.none.hide()
		else
			@elements.none.show()