direktlink_Finder= (i,el) ->
	console.log $(".direktlinks")[0].childNodes[2*i+1]
	return $(".direktlinks")[0].childNodes[2*i+1]

startSlideShow= () ->
	$('.slideshow').cycle( {
	fx: 'scrollHorz'
	speed: 1100
	easing: 'easeInOutSine'
	timeout: 0
	pagerAnchorBuilder: direktlink_Finder
	prev: $(".pfeil-links")
	next: $(".pfeil-rechts")
	} )

ganzLinks= (marker) ->
	return not ( marker.parentNode.parentNode.previousSibling && marker.parentNode.parentNode.previousSibling.previousSibling ) #IE8 erzeugt zu wenige Text-Nodes im DOM

ganzRechts= (marker) ->
	return not ( marker.parentNode.parentNode.nextSibling && marker.parentNode.parentNode.nextSibling.nextSibling ) #IE8 erzeugt zu wenige Text-Nodes im DOM


Template.tour.invokeAfterLoad = ->
  Meteor.defer () ->
  	startSlideShow()
  	

Template.tour.events =
  "click .tour-slider": (evt) ->
    evt.preventDefault()
    evt.currentTarget.blur()

    marker=$(".marker")[0]

    if(evt.currentTarget.className.indexOf("pfeil-links") != -1)
      #nach links
      if( not ganzLinks(marker) )
        newParent=marker.parentNode.parentNode.previousSibling.previousSibling.childNodes[1]
      else
        ul=marker.parentNode.parentNode.parentNode
        newParent=ul.childNodes[ul.childNodes.length-2].childNodes[1]
    else
      if(evt.currentTarget.className.indexOf("pfeil-rechts") != -1)
        #nach rechts
        if( not ganzRechts(marker) )
          newParent=marker.parentNode.parentNode.nextSibling.nextSibling.childNodes[1]
        else
          newParent=marker.parentNode.parentNode.parentNode.childNodes[1].childNodes[1]
      else
        #direkt
        newParent=evt.currentTarget.childNodes[1]

    marker.parentNode.removeChild(marker)
    newParent.insertBefore(marker, newParent.firstChild)
    
    if( ganzLinks(marker) )
    	$('.pfeil-links')[0].style.visibility="hidden"
    else
    	$('.pfeil-links')[0].style.visibility="visible"
    if( ganzRechts(marker) )
    	$('.pfeil-rechts')[0].style.visibility="hidden"
    else
    	$('.pfeil-rechts')[0].style.visibility="visible"
    
        
    
