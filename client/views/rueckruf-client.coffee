rueckrufAnfordern= () ->
  name=document.getElementsByName('name')[0].value
  telefon=document.getElementsByName('telefon')[0].value
  mail=document.getElementsByName('mail')[0].value
  unternehmen=document.getElementsByName('unternehmen')[0].value
  newsletterCheckbox=document.getElementsByName('newsletter')[0]
  newsletter=(newsletterCheckbox.checked)
  
  if document.getElementsByName('rueckruf').length > 0
    rueckrufCheckbox=document.getElementsByName('rueckruf')[0]
    rueckruf=(rueckrufCheckbox.checked)
  else
    rueckruf=true
  quelle_url=document.URL
  if $('.marker').length > 0
    quelle_slide=$('.marker')[0].nextSibling.nodeValue
    quelle_slide=$.trim( quelle_slide )
    if quelle_slide==""
      quelle_slide=$('.marker')[0].nextSibling.nextSibling.nodeValue
      quelle_slide=$.trim( quelle_slide )
  else
    quelle_slide=null
  Meteor.call("rueckrufAnforderungSpeichern", name, telefon, mail, unternehmen, newsletter, rueckruf, quelle_url, quelle_slide, rueckrufAnfordern_Callback)


rueckrufAnfordern_Callback= (error,result) ->
  if error
    console.log("Fehler beim Speichern des Rückrufs!")
    $('.overlay-slideshow').cycle(2) #Fehlermeldung anzeigen
  else
    console.log("Rückruf erfolgreich gespeichert")
    $('.overlay-slideshow').cycle(1) #Erfolgsmeldung anzeigen


