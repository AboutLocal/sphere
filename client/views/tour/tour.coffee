( () ->
  directlink_Finder= (i,el) ->
	  return $(".directlinks")[0].childNodes[2*i+1]

  startSlideShow= (startingSlide) ->
	  $('.slideshow').cycle( {
	  fx: 'scrollHorz'
	  speed: 400
	  easing: 'easeInOutSine'
	  timeout: 0
	  pagerAnchorBuilder: directlink_Finder
	  prev: $(".arrow-left")
	  next: $(".arrow-right")
	  startingSlide: startingSlide
	  } )

  myIndexOf= (array, element) ->
    (if array[i]==element then return i) for i in [0...array.length]
    return -1

  leftmost= (marker) ->
	  return not ( marker.parentNode.parentNode.previousSibling && marker.parentNode.parentNode.previousSibling.previousSibling ) #IE8 erzeugt zu wenige Text-Nodes im DOM

  rightmost= (marker) ->
	  return not ( marker.parentNode.parentNode.nextSibling && marker.parentNode.parentNode.nextSibling.nextSibling ) #IE8 erzeugt zu wenige Text-Nodes im DOM

  moveMarkerTo= (currentTarget) ->
	  marker=$(".marker")[0]

	  if(currentTarget.className.indexOf("arrow-left") != -1)
		  #go left
		  if( not leftmost(marker) )
		    newParent=marker.parentNode.parentNode.previousSibling.previousSibling.childNodes[1]
		  else
		    ul=marker.parentNode.parentNode.parentNode
		    newParent=ul.childNodes[ul.childNodes.length-2].childNodes[1]
	  else
		  if(currentTarget.className.indexOf("arrow-right") != -1)
		    #go right
		    if( not rightmost(marker) )
		      newParent=marker.parentNode.parentNode.nextSibling.nextSibling.childNodes[1]
		    else
		      newParent=marker.parentNode.parentNode.parentNode.childNodes[1].childNodes[1]
		  else
		    #go directly to slide
		    newParent=currentTarget.childNodes[1]

	  marker.parentNode.removeChild(marker)
	  newParent.insertBefore(marker, newParent.firstChild)

	  if( leftmost(marker) )
		  $('.arrow-left')[0].style.visibility="hidden"
	  else
		  $('.arrow-left')[0].style.visibility="visible"
	  if( rightmost(marker) )
		  $('.arrow-right')[0].style.visibility="hidden"
	  else
		  $('.arrow-right')[0].style.visibility="visible"


  Template.tour.invokeAfterLoad = ->
    Meteor.defer () ->
    
      Template.conversionBox.startOverlaySlideshow()
      
      try
        slideName=window.location.href.split('tour/')[1].split('/')[0] #"domain.tld/tour/SLIDENAME/" -> slidename herausparsen
      catch e
        return startSlideShow 0
      
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
      Template.conversionBox.hideOverlay()
      evt.preventDefault()

      
    "click .open-link": (evt) ->
      Template.conversionBox.showOverlay()
      evt.preventDefault()
)()
