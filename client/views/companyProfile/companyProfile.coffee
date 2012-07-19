Template.companyProfile.currentProfile = ->
  name: "Local Dog Care"
  sector: "Hundefriseur"
  iq: 96.7
  innovationState: "Early Adopter"
  averageRating: 4.2
  averagePopularity: 52.3
  street: "Beispielstraße 356"
  zip: "10405"
  city: "Berlin"
  phone: "030 / 444 555 67"
  fax: "030 / 444 555 68"
  homepage: "www.local-dog-care.de"
  email: "mail@local-dog-care.de"

Template.companyProfile.events =
  "click button": -> (
    console.log("button!")
    createPieChart "#pie", 75
  )

Template.companyProfile.invokeAfterLoad = ->
  Meteor.defer ->
    #console.log "ready."

