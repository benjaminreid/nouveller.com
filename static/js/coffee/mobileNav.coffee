class MovileNav
	constructor: ->
		@init()

	init: ->
		@getElements()
		@attachEvents()

	getElements: ->
		@elements =
			header: $ 'header.page-header'
			btn: $ '#displayNav'

	attachEvents: ->
		@elements.btn.on 'click touchstart', @toggleNav

	toggleNav: (e) =>
		e.preventDefault()
		@elements.btn.toggleClass 'active'
		@elements.header.toggleClass 'opened-up'