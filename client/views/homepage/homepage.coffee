Template.homepage.invokeAfterLoad = ->
  Meteor.defer () ->
	    Template.conversionBox.startOverlaySlideshow()
    	$('.quote-slideshow').cycle( {
	    fx: 'fade'
	    speed: 400
	    easing: 'easeInOutSine'
	    timeout: 10000
	    } )

Template.homepage.events =
  "click .close-link": (evt) ->
    Template.conversionBox.hideOverlay()
    evt.preventDefault()
    
  "click .open-link": (evt) ->
    Template.conversionBox.showOverlay()
    evt.preventDefault()
    



