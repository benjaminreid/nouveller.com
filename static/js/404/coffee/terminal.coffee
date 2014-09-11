class Message
	constructor: (@status, @text = '') ->
		@el = $ '<li />'
		@setup()

	setup: ->
		@setStatus()
		@setPrompt() if @status is 'sending'
		@setText()
		@setBlink() if @status is 'sending'

	setStatus: ->
		@el.addClass "t-message-#{@status}"

	setText: ->
		text = $ '<span />'
		text.addClass 'terminal-message'
		text.html @text
		@el.append text
		@message = text

	setPrompt: ->
		prompt = $ '<span />'
		prompt.addClass 'terminal-prompt'
		prompt.html '&gt;'
		@el.append prompt

	setBlink: ->
		blink = $ '<span />'
		blink.addClass 'terminal-blinker'
		@el.append blink
		run = =>
			blink.toggleClass 'terminal-blink'
		@interval = setInterval run, 500

	keyReceived: (e) ->
		if e.keyCode is 8
			# delete key is pressed
			# get current text
			text = @message.text()
			# chop of the end letter
			newMessage = text.substring(0, text.length - 1)
			# replace with new message
			@message.html newMessage
		else
			# normal typing, get the letter based of the character code
			letter = String.fromCharCode(e.keyCode).toLowerCase()
			# change space to html char
			letter = '&nbsp;' if e.keyCode is 32
			# append letter to end of message
			@message.append letter

	getMessage: ->
		@message.text().toLowerCase()

	setMessage: (msg) ->
		@message.text msg

	disable: ->
		@el.addClass 't-message-disable'
		@interval = clearInterval @interval

	get: -> @el

class Terminal
	constructor: (@parent, @responses) ->
		@listen = false
		@clearHistory()

	init: ->
		@getElements()
		@attachEvents()

	getElements: ->
		@elements =
			parent: @parent
			output: @parent.find '.terminal-output'
			body: $(document.body)

	attachEvents: ->
		@elements.body.on 'keydown', (e) =>
			@typed e if @listen

	typed: (e) =>
		# prevent space and backspace doing their worst
		e.preventDefault() if e.keyCode is 32
		e.preventDefault() if e.keyCode is 8


		# enter is pressed to grab the command 
		if e.keyCode is 13
			# send the input to the hendle function
			response = @current.getMessage()
			@handleMessage response
		else if e.keyCode is 38
			@historyLookup()
		else 
			# let the current message handle the rest
			@current.keyReceived e


	message: (type, text) ->
		# creates a new message instance, 
		m = new Message type, text

		# appends the message to the term
		@elements.output.append m.get()

		# set the current el
		@current = m

		# if sending a message back to the term, listen for it
		@listen = if type is 'sending' then true else false

	handleMessage: (response) ->
		# disable any more typing
		@listen = false
		# disable the current message
		@current.disable()

		responseNoSpaces = response.replace(/\s+/g, '');

		if @responses[responseNoSpaces]
			@responses[responseNoSpaces].call()
		else
			@responses['default'].call()

		@addHistory response

	historyLookup: ->
		if @sentMessages.length && @messagePos != 0
			@messagePos--
			text = @sentMessages[@messagePos]
			@current.setMessage text

	addHistory: (res) ->
		@sentMessages.push res
		@messagePos = @sentMessages.length

	clearHistory: ->
		@sentMessages = ['help']
		@messagePos = 1


window.JP.Terminal = Terminal