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
