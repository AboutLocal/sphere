Template.navCurrentGroup.events = 
  "click .open-innovation": (evt) ->
    Template.conversionBox.showOverlay('innovation')
    evt.preventDefault()

