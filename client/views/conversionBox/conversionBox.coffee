Template.conversionBox.hideOverlay= () ->
  $(".overlay-slideshow")[0].className="overlay-slideshow"
  $(".overlay-outer")[0].className="overlay-outer"

Template.conversionBox.showOverlay= () ->
  $('.overlay-slideshow').cycle(0) #Eingabemaske anzeigen
  $(".overlay-slideshow")[0].className="overlay-slideshow visible"
  $(".overlay-outer")[0].className="overlay-outer visible"


Template.conversionBox.startOverlaySlideshow= () ->
  $('.overlay-slideshow').cycle( {
  fx: 'fade'
  speed: 400
  easing: 'easeInOutSine'
  timeout: 0
  } )
  
  for slide in $('.overlay-inner')
    slide.style.backgroundColor='' #im IE ist die backgroundColor #f8f8f8



Template.conversionBox.requestCallBack= () ->
  name=document.getElementsByName('fullname')[0].value
  telephone=document.getElementsByName('telephone')[0].value
  email=document.getElementsByName('call-back-email')[0].value
  company=document.getElementsByName('company')[0].value
  callBackCheckbox=document.getElementsByName('callBack')[0]
  callBack=(callBackCheckbox.checked)
  
  source_url=document.URL
  if $('.marker').length > 0
    source_slide=$('.marker')[0].nextSibling.nodeValue
    source_slide=$.trim( source_slide )
    if source_slide==""
      source_slide=$('.marker')[0].nextSibling.nextSibling.nodeValue
      source_slide=$.trim( source_slide )
  else
    source_slide=null
  
  alert "call"
  
  Meteor.call("saveCallBackRequest", name, telephone, email, company, callBack, source_url, source_slide, Template.conversionBox.requestCallBack_Callback)


Template.conversionBox.requestCallBack_Callback= (error,result) ->

  alert "CB"

  if error
    #console.log("Fehler beim Speichern des Rückrufs!")
    $('.overlay-slideshow').cycle(2) #show error message
  else
    #console.log("Rückruf erfolgreich gespeichert")
    $('.overlay-slideshow').cycle(1) #show success message




Template.conversionBox.events =
    "click .call-back-button": (evt) ->
      evt.preventDefault()
      Template.conversionBox.requestCallBack()

