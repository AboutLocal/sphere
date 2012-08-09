(->

  Router = Backbone.Router.extend
    routes:
      "": "main"
      "tour/*path": "tour"
      "tour": "tour"
      "kontakt": "contact"
      "datenschutz": "privacy"
      "impressum": "imprint"
      "team": "team"

    main: () ->
      Session.set("currentPage", "homepage")

    tour: () ->
      Session.set("currentPage", "tour")

    contact: () ->
      Session.set("currentPage", "contact")

    privacy: () ->
      Session.set("currentPage", "privacyPolicy")

    imprint: () ->
      Session.set("currentPage", "imprint")
    team: () ->
      Session.set("currentPage", "team")

  router = new Router

  Template.layout.currentPage = ->
    return new Handlebars.SafeString Meteor.ui.chunk Template[Session.get "currentPage"]

  Meteor.startup () ->
    Backbone.history.start pushState: true

    scrollElement = $(document.body)

    jQuery(document.body).on "click", "a[href]", (evt) ->
      href = $(@).attr "href"
      protocol = @protocol + "//"

      if href and href.slice(0, protocol.length) isnt protocol and href isnt "#" and href.indexOf "javascript:" isnt 0
        evt.preventDefault()
        scrollElement.animate {scrollTop: 0}, "100ms", "swing"
        router.navigate href, trigger: true


    document.body.appendChild Meteor.ui.render Template.layout

)()
