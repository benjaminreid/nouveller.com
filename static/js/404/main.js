window.JP = {};

(function() {
	$(document).ready(function() {

		var termWindow, term, responses, count, ahahah, uhuhuh_sound, music, magicPopup, magicEl, termPopup, termEl, babePopup, babeEl, powerPopup, powerEl, dimmer, init, visited, storeKey, video_url, fadeOutSound, muteKey, muted, setMuteState, checkStatus, dragOptions, muteBtn, closeBtn, sharePopup, shareEl, toggleMusic, playMusic, pauseMusic;
		
		// ******************************
		// elements
		//
		magicEl    = $('#magicPopup'),
		termEl     = $('#termPopup'),
		babeEl     = $('#babePopup'),
		powerEl    = $('#powerPopup'),
		dimmer     = $('#dimmerSwitch'),
		muteBtn    = $('#muteToggle'),
		closeBtn   = $('#closeBtn'),
		shareEl    = $('#sharePopup'),
		termWindow = $('#mainTerm');

		// ******************************
		// vars
		//
		
		// states for the park systems
		hones     = false,
		perimeter = false,
		phones 		= false,
		security  = false,
		count     = 0;

		// ******************************
		// visited the page check
		//
		storeKey = 'visited404';
		visited = store.get(storeKey) || false;
		if ( ! visited ) {
			store.set(storeKey, true);
		}

		// ******************************
		// check the mute state
		//
		muteKey = 'muted404';
		muted = store.get(muteKey) || false;
		setMuteState = function(state) {
			muted = state;
			store.set(muteKey, state);
		};

		if (muted) {
			muteBtn.addClass('active');
		}

		playMusic = function() {
			setMuteState(false);
			music.unmute();
			_gaq.push(['_trackEvent', 'JP404', 'Un-Muted sound']);
			muteBtn.removeClass('active');
		};

		pauseMusic = function() {
			setMuteState(true);
			music.mute();
			_gaq.push(['_trackEvent', 'JP404', 'Mute sound']);
			muteBtn.addClass('active');
		};

		toggleMusic = function() {
			if (muted) {
				playMusic();
			} else {
				pauseMusic();
			}
		};

		muteBtn.on('click', function(e) {
			e.preventDefault();
			toggleMusic();
		});

		// ******************************
		// popups
		//
		magicPopup 	= new JP.Popup(magicEl);
		termPopup 	= new JP.Popup(termEl);
		babePopup 	= new JP.Popup(babeEl);
		powerPopup 	= new JP.Popup(powerEl);
		sharePopup 	= new JP.Popup(shareEl);

		dragOptions = {
			handle: '.handle',
			stack: '.popup'
		};
		magicEl.draggable(dragOptions);
		termEl.draggable(dragOptions);
		babeEl.draggable(dragOptions);
		powerEl.draggable(dragOptions);

		// ******************************
		// arb functions
		//

		closeBtn.on('click', function(e) {
			e.preventDefault();
			soundManager.stopAll();
			dimmer.fadeOut(500, function() {
				dimmer.remove();
			});
			_gaq.push(['_trackEvent', 'JP404', 'Closed']);
		});

		// main function to kick things off
		init = function() {

			dimmer.fadeIn(500, function() {
				termPopup.open(function() {
					term.message('received', 'Jurassic Park, System Security Interface');
					term.message('received', 'Version 4.0.5, Alpha E');
					term.message('received', 'Ready...');
					term.message('alert', 'Park offline, reboot required');
					if (visited) {
						_gaq.push(['_trackEvent', 'JP404', 'Second visit']);
						term.message('info', 'Session restored - type <strong>help</strong> for command list');
					}
					term.message('sending');
				});
				babePopup.open();
			});			

		};

		// you didn't say the magic word!
		// fired when you enter 3 wrong answers
		ahahah = function() {
			var count, max, interval;

			fadeOutSound('music', 1);

			count = 0;
			max 	= 100;

			interval = setInterval(function() {
				term.message('received', "YOU DIDN'T SAY THE MAGIC WORD!");
				count++;
				if (count >= max) {
					interval = clearInterval(interval);
					term.message('received', '<a href="">Reboot and try again</a>');
				}
			}, 20);

			magicEl.css({'zIndex': 2000});
			magicPopup.open();
			uhuhuh_sound.play({loops:100});	
			sharePopup.open(function() {
				$('#twitter-load a').addClass('twitter-follow-button');
				twttr.widgets.load();
			});
			_gaq.push(['_trackEvent', 'JP404', 'Failed']);
		};

		// every time a system is turned on and status is run
		checkStatus = function() {
			term.message(((phones) ? 'success' : 'alert'), ((phones) ? 'phones online' : 'phones offline'));
			term.message(((perimeter) ? 'success' : 'alert'), ((perimeter) ? 'perimeter fences up' : 'perimeter fences down'));
			term.message(((security) ? 'success' : 'alert'), ((security) ? 'security systems activated' : 'security systems de-activated'));

			if (phones === true && perimeter === true && security === true) {	
				// JP is back online!
				powerEl.css({'zIndex': 2000});
				powerPopup.open(function() {
					$(this).find('video').get(0).play();
					fadeOutSound('music', 1);
					term.message('success', '<strong>Jurassic Park is back online!</strong>');
					_gaq.push(['_trackEvent', 'JP404', 'Success']);
					setTimeout(function() {
						sharePopup.open(function() {
							$('#twitter-load a').addClass('twitter-follow-button');
							twttr.widgets.load();
						});
					}, 9000);
				});
			} else {
				term.message('sending');
			}
		};

		// fades out a sound by ID and amount
		fadeOutSound = function(soundID, amount) {
			var s = soundManager.getSoundById(soundID);
			var vol = s.volume;
			if (vol == 0) return false;
			s.setVolume(Math.max(0,vol-amount));
			setTimeout(function(){fadeOutSound(soundID,amount)},20);
		}
		
		// ******************************
		// terminal
		//
		
		// responses to the term input
		responses = {
			default: function() {
				var response;
				response = 'access: PERMISSION DENIED.';
				count++;
				if (count == 3) {
					response = 'access: PERMISSION DENIED....and....';
					setTimeout(ahahah, 1000);
				}
				term.message('received', response);
				if (count < 3) {
					term.message('sending');
				}	
			},
			help: function() {
				term.message('info', 'commands: <strong>help</strong>, <strong>status</strong>, <strong>reboot</strong>, <strong>moff</strong>, <strong>trex</strong>');
				term.message('sending');
			},
			'': function() {
				term.message('received', 'command not found. type <strong>help</strong> for command list');
				term.message('sending');
			},
			status: function() {
				checkStatus();	
			},
			trex: function() {
				window.open("https://www.youtube.com/watch?v=--40RLF5UGo");
				term.message('sending');
				pauseMusic();
			},
			moff: function() {
				window.open("http://www.youtube.com/watch?v=P8EBKPuKdR4");
				term.message('sending');
				pauseMusic();
			},
			reboot: function() {
				term.message('received', 'missing parameter, try <strong>reboot</strong> &lt;system&gt; or <strong>status</strong>');
				term.message('sending');
			},
			'rebootphones': function() {
				phones = true;
				checkStatus();
			},
			'rebootperimeter': function() {
				perimeter = true;
				checkStatus();
			},
			'rebootperimeterfences': function() {
				perimeter = true;
				checkStatus();
			},
			'rebootfences': function() {
				perimeter = true;
				checkStatus();
			},
			'rebootsecurity': function() {
				security = true;
				checkStatus();
			},
			'rebootsecuritysystems': function() {
				security = true;
				checkStatus();
			},
			'sudorebootall': function() {
				phones = true;
				security = true;
				perimeter = true;
				checkStatus();
			}
		};

		// init JP terminal
		term = new JP.Terminal(termWindow, responses);
		term.init();

		// kick everything off from the sound manager
		soundManager.setup({      			
			flashVersion: 9,
			url: '/static/js/404/soundmanager2/swf/',
			onready: function() {

				// create sounds needed
				uhuhuh_sound = soundManager.createSound({
 					id: 'uhuhuh',
 					url: '/static/sound/404/uh-uh-uh-56bit.mp3',
 					autoLoad: true
				});

				music = soundManager.createSound({
					id: 'music',
					url: '/static/sound/404/nedry.mp3',
					autoLoad: true,
					autoPlay: true,
					stream: true,
					volume: 25,
					loops: 1000
				});

				if (muted) {
					music.mute();
				}

				// fire off the init function after a delay
				setTimeout(init, 500);			
			}
    });

		_gaq.push(['_trackEvent', 'JP404', 'Loaded']);

	});
})();