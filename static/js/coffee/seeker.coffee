$(document).ready ->
	
	# filter
	new Filter $('#work-filter'), $('#work-filter-list')

	new Shadow

	new MovileNav

	code = $ 'pre'
	code.wrapInner '<code/>'
	code.find('code').addClass 'prettyprint linenums'
	prettyPrint()

	new Extender $('#articlesCat')
	new Extender $('#tagList')

	Modernizr.load
		test: Modernizr.input.placeholder
		nope: '/static/js/libs/example.js'
		complete: () ->
			if $.fn.example
				input = $ 'input[placeholder]'
				input.example -> $(this).attr 'placeholder'

	# twitter widget
	`!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");`

	# google widget
	`(function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();`