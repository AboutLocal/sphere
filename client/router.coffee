(->

  Router = Backbone.Router.extend
    routes:
      "": "main"
      "tour": "tour"
      "kontakt": "contact"
      "datenschutz": "privacy"
      "impressum": "imprint"

    main: () ->
      Session.set("currentPage", "homepage")

    tour: () ->
      Session.set("currentPage", "tour")

    contact: () ->
      Session.set("currentPage", "kontakt")

    privacy: () ->
      Session.set("currentPage", "privacyPolicy")

    imprint: () ->
      Session.set("currentPage", "imprint")

  router = new Router

  Template.layout.currentPage = ->
    return new Handlebars.SafeString Meteor.ui.chunk Template[Session.get "currentPage"]

  Meteor.startup () ->
    Backbone.history.start pushState: true

    jQuery(document.body).on "click", "a[href]", (evt) ->
      evt.preventDefault()
      evt.stopPropagation()
      path = evt.currentTarget.href.replace(/^https?:\/\/[^/]+\//, "")
      router.navigate path, trigger: true

    document.body.appendChild Meteor.ui.render Template.layout

)()
