class Rpc
  @login = (username, password) ->
    promise = jQuery.Deferred()
    Meteor.call "login", username, password, (error, sessionToken) ->
      if error?
        promise.reject error
      else
        AuthN.setSessionToken(sessionToken)
        promise.resolve()
    return promise
  @track = (() ->
    q = []
    timeoutId = null
    isRunning = false
    console.log "built queue"
    (evt) ->
      evt.timestamp = Date.now()
      q.push evt
      return if isRunning
      tries = 5
      window.clearTimeout timeoutId if timeoutId?
      timeoutId = window.setTimeout (() ->
        isRunning = true
        evts = q
        q = []
        tryCall = () ->
          Meteor.call "trackEvents", AuthN.getSessionToken(), evts, (error) ->
            if error? && tries-- > 0
              tryCall()
            else
              isRunning = false
        tryCall()
      ), 500
  )()
