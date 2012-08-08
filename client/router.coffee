(->

  Router = Backbone.Router.extend
    routes:
      "": "main"
      "tour": "tour"

    main: () ->
      Session.set("currentPage", "homepage")

    tour: () ->
      Session.set("currentPage", "tour")

  router = new Router

  Template.layout.currentPage = ->
    return new Handlebars.SafeString Meteor.ui.chunk Template[Session.get "currentPage"]

  Meteor.startup () ->
    Backbone.history.start pushState: true

    jQuery(document.body).on "click", "a[href]", (evt) ->
      evt.preventDefault()
      evt.stopPropagation()
      console.log evt
      path = evt.currentTarget.href.replace(/^https?:\/\/[^/]+\//, "")
      console.log path
      router.navigate path, trigger: true

    document.body.appendChild Meteor.ui.render Template.layout

)()
