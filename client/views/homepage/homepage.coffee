Template.homepage.invokeAfterLoad = ->
  Meteor.defer () ->
	    startOverlaySlideshow()
    	$('.quote-slideshow').cycle( {
	    fx: 'fade'
	    speed: 400
	    easing: 'easeInOutSine'
	    timeout: 10000
	    } )

Template.homepage.events =
  "click .close-link": (evt) ->
    hideOverlay()
    evt.preventDefault()
    
  "click .open-link": (evt) ->
    showOverlay()
    evt.preventDefault()
    
  "click .call-back-button": (evt) ->
    evt.preventDefault()
    requestCallBack()


