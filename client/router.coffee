(->

  track = () ->
    try
      action = new TrackedAction.PageView
      action.page = Session.get "currentPage"
      Rpc.track action
    catch ignored
      return

  Router = Backbone.Router.extend
    routes:
      "": "main"
      "tour/*path": "tour"
      "tour": "tour"
      "kontakt": "contact"
      "datenschutz": "privacy"
      "impressum": "imprint"
      "team": "team"
      "team#*anchor": "team"

    main: () ->
      Session.set("currentPage", "homepage")
      Template.navigation.homepageActiveClass="current"
      track()

    tour: () ->
      Session.set("currentPage", "tour")
      Template.navigation.tourActiveClass="current"
      track()

    contact: () ->
      Session.set("currentPage", "contact")
      track()

    privacy: () ->
      Session.set("currentPage", "privacyPolicy")
      track()

    imprint: () ->
      Session.set("currentPage", "imprint")
      track()

    team: () ->
      Session.set("currentPage", "team")
      track()

  router = new Router

  Template.layout.currentPage = ->
    Template.navigation.homepageActiveClass=""
    Template.navigation.tourActiveClass=""
    return new Handlebars.SafeString Meteor.ui.chunk Template[Session.get "currentPage"]

  Meteor.startup () ->
    Backbone.history.start pushState: true

    #$(document.body).css("min-height", $(window).height() + "px")

    scrollElement = $("html, body")

    jQuery(document.body).on "click", "a[href]", (evt) ->
      href = $(@).attr "href"
      protocol = @protocol + "//"

      if href and href.slice(0, protocol.length) isnt protocol and href isnt "#" and href.indexOf("javascript:") isnt 0 and href.indexOf("mailto:") isnt 0
        evt.preventDefault()
        Meteor.defer (() ->
          scrollElement.animate {scrollTop: 0}, "100ms", "swing"
        )
        router.navigate href, trigger: true


    document.body.appendChild Meteor.ui.render Template.layout

)()
