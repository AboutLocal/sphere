Template.team.invokeAfterLoad = ->
  Meteor.defer () ->
    $("#team-slider").nivoSlider({
      pauseTime: 7000
      effect: "fade"
      animSpeed: "200"
    })


Template.team.events =
  "click .openings-button": (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    $("html, body").animate({
    scrollTop: $("#join-us-headline").offset().top
    }, 200)
    

    

