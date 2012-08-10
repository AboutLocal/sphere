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
          sessionToken = AuthN.getSessionToken()
          if sessionToken is AuthN.DEFAULT_TOKEN or not sessionToken?
            Meteor.call "trackAnonymousEvents", Session.get("fingerprint"), Session.get("trackingCookie"), evts, (error) ->
              if error? && tries-- > 0
                console.error error
                tryCall()
              else
                isRunning = false
          else
            Meteor.call "trackEvents", AuthN.getSessionToken(), evts, (error) ->
              if error? && tries-- > 0
                console.error error
                tryCall()
              else
                isRunning = false
        tryCall()
      ), 500
  )()
