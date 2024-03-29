callBacks=new Meteor.Collection("callBack")


saveCallBackRequest= (name, telephone, email, company, callBack, source_url, source_slide, lightbox) ->
  
  callBacks.insert( {
  name: name
  telephone: telephone
  email: email
  company: company
  callBack: callBack
  source_url: source_url
  source_slide: source_slide
  lightbox: lightbox
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
  to: "info@about-local.com"
  subject: "Kontaktanfrage"
  text: """Es gibt eine neue Kontaktanfrage:
  
  Name: #{name}
  Unternehmen: #{company}
  Telefon: #{telephone}
  Email: #{email}
  Lightbox: \"#{lightbox}\"
  Rückruf gewünscht: #{ if (callBack) then "Ja" else "Nein" }
  """
  
  }, saveCallBackRequest_Callback )
  
  transport.close()


saveCallBackRequest_Callback= (error, responseStatus) ->
  if error
    #console.log error
  else
    #console.log responseStatus.message
  

Meteor.methods({saveCallBackRequest:saveCallBackRequest})


