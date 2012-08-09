
Meteor.startup () ->
  AuthN.initializeSessionToken

class AuthN

  @COOKIE_TOKEN_KEY: "ABTLCLS"
  @DEFAULT_TOKEN: "guest"
  @EXPIRES: 7

  @initializeSessionToken: () ->
    Session.set("token", jQuery.cookie(@COOKIE_TOKEN_KEY) || @DEFAULT_TOKEN)

  @setSessionToken: (sessionToken) ->
    sessionToken ?= @DEFAULT_TOKEN
    jQuery.cookie @COOKIE_TOKEN_KEY, sessionToken, expires: @EXPIRES, path: "/"
    Session.set "token", sessionToken

  @clearSessionToken: () ->
    $.cookie @DEFAULT_TOKEN
    Session.set "token", @DEFAULT_TOKEN

  @getSessionToken: () ->
    Session.get "token"
