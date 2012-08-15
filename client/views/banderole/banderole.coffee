Template.banderole.events =
  "click .banderole": (evt) ->
    if(window.location.href.indexOf("team")!=-1)
      evt.preventDefault()
      evt.stopPropagation()
      Template.team.scrollToJobs()


