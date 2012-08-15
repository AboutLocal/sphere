Template.team.invokeAfterLoad = ->
  Meteor.defer () ->
    anchor=window.location.href.split('team#')[1] #"domain.tld/team#ANCHOR" -> anchor herausparsen
    if anchor=="join-us-headline"
      setTimeout( () ->
        Template.team.scrollToJobs()
      , 150)
    
    speed=200
    if($.browser.mozilla)
      speed*=firefoxAnimspeedFactor
    
    $("#team-slider").nivoSlider({
      pauseTime: 7000
      effect: "fade"
      animSpeed: speed
    })


Template.team.scrollToJobs= () ->
    $("html, body").animate({
    scrollTop: $("#join-us-headline").offset().top
    }, 200)



Template.team.events =
  "click .openings-button": (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Template.team.scrollToJobs()


