#SHOWING AND HIDING

Template.conversionBox.hideOverlay= () ->
  $(".overlay-slideshow")[0].className="overlay-slideshow"
  $(".overlay-outer")[0].className="overlay-outer"

Template.conversionBox.showOverlay= (contentname) ->
  Template.conversionBox.setVariableContent(contentname)
  
  $('.overlay-slideshow').cycle(0) #Eingabemaske anzeigen
  $(".overlay-slideshow")[0].className="overlay-slideshow visible"
  $(".overlay-outer")[0].className="overlay-outer visible"


Template.conversionBox.invokeAfterLoad= () ->
  Meteor.defer () ->
    Template.conversionBox.startOverlaySlideshow()
    Template.conversionBox.form=$('.conversionbox-form')[0]
    Template.conversionBox.variableContent="xxx"

Template.conversionBox.startOverlaySlideshow= () ->
  speed=400
  if($.browser.mozilla)
    speed*=firefoxAnimspeedFactor
  
  $('.overlay-slideshow').cycle( {
  fx: 'fade'
  speed: speed
  easing: 'easeInOutSine'
  timeout: 0
  } )
  
  for slide in $('.overlay-inner')
    slide.style.backgroundColor='' #im IE ist die backgroundColor #f8f8f8




#SUBMITTING THE FORM

Template.conversionBox.isSubmitting=false

Template.conversionBox.spinner = new Spinner
    lines: 9
    length: 0
    width: 4
    radius: 7
    rotate: 0
    color: "#fff"
    speed: 1.0
    trail: 60
    shadow: false
    hwaccel: true
    className: "conversionbox-spinner"
    zIndex: 2e9
    top: "auto"
    left: "auto"


Template.conversionBox.resetTextinputs= () ->
  textinputs=$(Template.conversionBox.form).find('input[type="text"]')
  for input in textinputs
    input.className=""


Template.conversionBox.requestCallBack_Callback= (error,result) ->
  setTimeout( () ->
    Template.conversionBox.button.text( Template.conversionBox.oldText )
    Template.conversionBox.resetTextinputs()
  ,
  500 )
  Template.conversionBox.spinner.stop()
  Template.conversionBox.isSubmitting=false
  if error
    #console.log("Fehler beim Speichern des Rückrufs!")
    $('.overlay-slideshow').cycle(2) #show error message
  else
    #console.log("Rückruf erfolgreich gespeichert")
    $('.overlay-slideshow').cycle(1) #show success message



Template.conversionBox.events =
    "click .close-link": (evt) ->
      Template.conversionBox.hideOverlay()
      evt.preventDefault()

      
    "submit form": (evt) ->
      evt.preventDefault()
      return if Template.conversionBox.isSubmitting

      name=document.getElementsByName('fullname')[0].value
      telephone=document.getElementsByName('telephone')[0].value
      email=document.getElementsByName('call-back-email')[0].value
      company=document.getElementsByName('company')[0].value
      callBackCheckbox=document.getElementsByName('callBack')[0]
      callBack=(callBackCheckbox.checked)
      
      Template.conversionBox.resetTextinputs()
      hasError = false
      textinputs=$(Template.conversionBox.form).find('input[type="text"]')
      for input in textinputs
        if input.value==""
          input.className = "error"
          hasError = true

      return if hasError

      Template.conversionBox.isSubmitting = true

      Template.conversionBox.button = $ "button", Template.conversionBox.form
      Template.conversionBox.oldText = Template.conversionBox.button.text()
      Template.conversionBox.button.text("Bitte warten…")
      Template.conversionBox.spinner.spin()
      Template.conversionBox.button.prepend Template.conversionBox.spinner.el
      
      source_url=document.URL
      if $('.marker').length > 0
        source_slide=$('.marker')[0].nextSibling.nodeValue
        source_slide=$.trim( source_slide )
        if source_slide==""
          source_slide=$('.marker')[0].nextSibling.nextSibling.nodeValue
          source_slide=$.trim( source_slide )
      else
        source_slide=null

      lightbox=$('.variablecontent-headline')[0].innerHTML
      
      Meteor.call("saveCallBackRequest", name, telephone, email, company, callBack, source_url, source_slide, lightbox, Template.conversionBox.requestCallBack_Callback)



#VARIABLE CONTENT

Template.conversionBox.setVariableContent= (contentname) ->
  headline=$('.variablecontent-headline')[0]
  switch contentname
    when "innovation"
      headline.innerHTML="Werden Sie Innovationspartner!";
      $('.telephone-box')[0].className += " variable-content-invisible"
      $('.innovation-partner-box')[0].className = "innovation-partner-box"
    else 
      headline.innerHTML="Fordern Sie weitere Informationen an!";
      $('.innovation-partner-box')[0].className += " variable-content-invisible"
      $('.telephone-box')[0].className = "telephone-box"

