rueckrufe=new Meteor.Collection("rueckruf")


rueckrufAnforderungSpeichern= (name, telefon, mail, unternehmen, newsletter, rueckruf, quelle_url, quelle_slide) ->
  rueckrufe.insert( {
  name: name
  telefon: telefon
  mail: mail
  unternehmen: unternehmen
  newsletter: newsletter
  rueckruf: rueckruf
  quelle_url: quelle_url
  quelle_slide: quelle_slide
  } )
  
  nodemailer=require('nodemailer')
  transport=nodemailer.createTransport("SMTP", {
  service: "Gmail"
  auth: {
  user: "martin.gebert@about-local.com"
  pass: "Umfigui1"
  }
  } )
  
  transport.sendMail( {
  from: "martin.gebert@about-local.com"
  to: "martin.gebert@about-local.com"
  subject: "Kontaktanfrage"
  text: """Es gibt eine neue Kontaktanfrage:
  
  Name: #{name}
  Telefon: #{telefon}
  Email: #{mail}
  Unternehmen: #{unternehmen}
  Rückruf gewünscht: #{ if (rueckruf) then "Ja" else "Nein" }
  """
  
  }, rueckrufAnforderungSpeichern_Callback )
  
  transport.close()


rueckrufAnforderungSpeichern_Callback= (error, responseStatus) ->
  if error
    #console.log error
  else
    #console.log responseStatus.message
  

Meteor.methods({rueckrufAnforderungSpeichern:rueckrufAnforderungSpeichern})


