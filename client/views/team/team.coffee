Template.team.invokeAfterLoad = ->
  Meteor.defer () ->
    speed=200
    if($.browser.mozilla)
      speed*=firefoxAnimspeedFactor
    
    $("#team-slider").nivoSlider({
      pauseTime: 7000
      effect: "fade"
      animSpeed: speed
    })


Template.team.events =
  "click .openings-button": (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    $("html, body").animate({
    scrollTop: $("#join-us-headline").offset().top
    }, 200)
    

    

