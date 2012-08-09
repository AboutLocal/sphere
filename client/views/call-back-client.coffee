requestCallBack= () ->
  name=document.getElementsByName('name')[0].value
  telephone=document.getElementsByName('telephone')[0].value
  email=document.getElementsByName('call-back-email')[0].value
  company=document.getElementsByName('company')[0].value
  newsletterCheckbox=document.getElementsByName('newsletter')[0]
  newsletter=(newsletterCheckbox.checked)
  
  if document.getElementsByName('call-back').length > 0
    callBackCheckbox=document.getElementsByName('call-back')[0]
    callBack=(callBackCheckbox.checked)
  else
    callBack=true
  source_url=document.URL
  if $('.marker').length > 0
    source_slide=$('.marker')[0].nextSibling.nodeValue
    source_slide=$.trim( source_slide )
    if source_slide==""
      source_slide=$('.marker')[0].nextSibling.nextSibling.nodeValue
      source_slide=$.trim( source_slide )
  else
    source_slide=null
  Meteor.call("saveCallBackRequest", name, telephone, email, company, newsletter, callBack, source_url, source_slide, requestCallBack_Callback)


requestCallBack_Callback= (error,result) ->
  if error
    console.log("Fehler beim Speichern des Rückrufs!")
    $('.overlay-slideshow').cycle(2) #show error message
  else
    console.log("Rückruf erfolgreich gespeichert")
    $('.overlay-slideshow').cycle(1) #show success message


