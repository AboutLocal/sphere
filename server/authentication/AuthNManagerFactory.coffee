class AuthNManagerFactory

  @buildManager = (serverKey, options) ->

    settings = _.extend {
      userCollection: Users,
      usernameField: "login",
      passwordHashField: "passwordHash",
      sessionCollection: UserSessions,
      sessionLongevitySeconds: 7 * 24 * 60 * 60
    }, options

    AuthUsers = settings.userCollection
    AuthUserSessions = settings.sessionCollection

    getUserSessionBySessionToken = (sessionToken) ->
      return unless isSessionTokenValid sessionToken

      hash = getSessionTokenHash sessionToken
      session = AuthUserSessions.findOne hash: hash
      return unless session?

      return session if Date.now() <= session.expires

      AuthUserSessions.remove _id: session._id
      return

    getUserBySessionToken = (sessionToken) ->
      session = getUserBySessionToken sessionToken
      return unless session?

      AuthUsers.findOne _id: session.userId

    generatePasswordHash = (password) ->
      bcrypt = require "bcrypt"
      salt = bcrypt.genSaltSync 10
      hash = bcrypt.hashSync password, salt

    getSessionTokenHash = (sessionToken) ->
      CryptoJS.SHA256(sessionToken).toString()

    isUserPasswordCorrect = (user, testPassword) ->
      userPassword = user?[settings.passwordHashField]
      return false unless userPassword?
      require("bcrypt").compareSync testPassword, userPassword

    generateSignedToken = () ->
      randomToken = CryptoJS.SHA256(Math.random().toString()).toString()
      signature = CryptoJS.HmacMD5(randomToken, serverKey).toString()
      randomToken + ":" + signature

    isSessionTokenValid = (sessionToken) ->
      return false unless sessionToken
      [token, signature] = sessionToken.split ":"
      signature is CryptoJS.HmacMD5(token, serverKey).toString()

    getSessionTokenForUser = (user) ->
      sessionToken = generateSignedToken()
      hash = getSessionTokenHash(sessionToken)
      AuthUserSessions.insert {
        userId: user._id
        hash: hash
        expires: new Date(Date.now() + settings.sessionLongevitySeconds * 1000).getTime()
      }
      sessionToken

    getSessionTokenForUsernamePassword = (username, password) ->
      query = {}
      query[settings.usernameField] = username
      user = AuthUsers.findOne query
      return unless user?
      if isUserPasswordCorrect user, password
        return getSessionTokenForUser user
      return

    clearUserSessions = (sessionToken) ->
      user = getUserBySessionToken sessionToken
      return false unless user?
      AuthUserSessions.remove userId: user_id
      return true


    return {
      getSessionTokenForUsernamePassword: getSessionTokenForUsernamePassword
      clearUserSessions: clearUserSessions
      getUserBySessionToken: getUserBySessionToken
      generatePasswordHash: generatePasswordHash
      isUserPasswordCorrect: isUserPasswordCorrect
    }
