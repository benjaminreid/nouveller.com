class Popup
	constructor: (@parent) ->

	open: (cb = false) ->
		container = @parent
		@parent.fadeIn 0, ->
			cb.call(container) if typeof cb is 'function'

	close: ->
		@parent.fadeOut 0, =>
			@parent.remove()

window.JP.Popup = Popup