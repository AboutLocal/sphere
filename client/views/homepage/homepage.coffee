Template.homepage.events =
  "click .close-link": (evt) ->
    hideOverlay()
    evt.preventDefault()
    
  "click .open-link": (evt) ->
    showOverlay()
    evt.preventDefault()

