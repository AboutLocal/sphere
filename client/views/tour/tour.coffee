( () ->
  direktlink_Finder= (i,el) ->
	  return $(".direktlinks")[0].childNodes[2*i+1]

  startSlideShow= (startSlide) ->
	  $('.slideshow').cycle( {
	  fx: 'scrollHorz'
	  speed: 400
	  easing: 'easeInOutSine'
	  timeout: 0
	  pagerAnchorBuilder: direktlink_Finder
	  prev: $(".pfeil-links")
	  next: $(".pfeil-rechts")
	  startingSlide: startSlide
	  } )

  myIndexOf= (array, element) ->
    (if array[i]==element then return i) for i in [0...array.length]
    return -1

  ganzLinks= (marker) ->
	  return not ( marker.parentNode.parentNode.previousSibling && marker.parentNode.parentNode.previousSibling.previousSibling ) #IE8 erzeugt zu wenige Text-Nodes im DOM

  ganzRechts= (marker) ->
	  return not ( marker.parentNode.parentNode.nextSibling && marker.parentNode.parentNode.nextSibling.nextSibling ) #IE8 erzeugt zu wenige Text-Nodes im DOM

  moveMarkerTo= (currentTarget) ->
	  marker=$(".marker")[0]

	  if(currentTarget.className.indexOf("pfeil-links") != -1)
		  #nach links
		  if( not ganzLinks(marker) )
		    newParent=marker.parentNode.parentNode.previousSibling.previousSibling.childNodes[1]
		  else
		    ul=marker.parentNode.parentNode.parentNode
		    newParent=ul.childNodes[ul.childNodes.length-2].childNodes[1]
	  else
		  if(currentTarget.className.indexOf("pfeil-rechts") != -1)
		    #nach rechts
		    if( not ganzRechts(marker) )
		      newParent=marker.parentNode.parentNode.nextSibling.nextSibling.childNodes[1]
		    else
		      newParent=marker.parentNode.parentNode.parentNode.childNodes[1].childNodes[1]
		  else
		    #direkt
		    newParent=currentTarget.childNodes[1]

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


  Template.tour.invokeAfterLoad = ->
    Meteor.defer () ->
    
      startOverlaySlideshow()
      
      slideName="profile-slide" # diesen Parameter aus GET auslesen
      
      if $('div.'+slideName).length > 0 and $('a.'+slideName).length > 0
        slideIndex=myIndexOf( $('.slideshow')[0].childNodes, $('div.'+slideName)[0] )
        slideIndex= Math.floor( (slideIndex+1) / 2 ) - 1
        startSlideShow(slideIndex)
        moveMarkerTo( $('a.'+slideName)[0] )
      else
        startSlideShow(0)


  Template.tour.events =
    "click .tour-slider": (evt) ->
      evt.preventDefault()
      evt.currentTarget.blur()
      moveMarkerTo(evt.currentTarget)

      
    "click .close-link": (evt) ->
      hideOverlay()
      evt.preventDefault()

      
    "click .open-link": (evt) ->
      showOverlay()
      evt.preventDefault()
      
      
    "click .rueckrufButton": (evt) ->
      evt.preventDefault()
      rueckrufAnfordern()
)()
