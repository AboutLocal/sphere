Template.homepage.invokeAfterLoad = ->
  Meteor.defer () ->
      speed=400
      
      if($.browser.mozilla)
        speed*=firefoxAnimspeedFactor
      
      $('.quote-slideshow').cycle( {
      fx: 'fade'
      speed: speed
      easing: 'easeInOutSine'
      timeout: 10000
      } )

Template.homepage.events =
  "click .open-link": (evt) ->
    Template.conversionBox.showOverlay('telephone')
    evt.preventDefault()
    



