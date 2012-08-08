hideOverlay= () ->
  $(".overlay-slideshow")[0].className="overlay-slideshow"
  $(".overlay-outer")[0].className="overlay-outer"

showOverlay= () ->
  $('.overlay-slideshow').cycle(0) #Eingabemaske anzeigen
  $(".overlay-slideshow")[0].className="overlay-slideshow visible"
  $(".overlay-outer")[0].className="overlay-outer visible"


startOverlaySlideshow= () ->
  $('.overlay-slideshow').cycle( {
  fx: 'fade'
  speed: 400
  easing: 'easeInOutSine'
  timeout: 0
  } )
  
  for slide in $('.overlay-inner')
    slide.style.backgroundColor='' #im IE ist die backgroundColor sind #f8f8f8


