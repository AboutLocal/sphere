Template.homepage.invokeAfterLoad = ->
  Meteor.defer () ->
	    startOverlaySlideshow()
    	$('.zitat-slideshow').cycle( {
	    fx: 'fade'
	    speed: 400
	    easing: 'easeInOutSine'
	    timeout: 5000
	    } )

Template.homepage.events =
  "click .close-link": (evt) ->
    hideOverlay()
    evt.preventDefault()
    
  "click .open-link": (evt) ->
    showOverlay()
    evt.preventDefault()
    
  "click .rueckrufButton": (evt) ->
    evt.preventDefault()
    rueckrufAnfordern()


