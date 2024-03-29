###
These RPC methods are available on both the
server and the client. When called on the
server, they are authoritative. When called
on the client, authorization is skipped
where the client doesn't have enough info
to make a judgement call. The server will
take care of it. Meteor handles this for us.
###

Meteor.methods

  ###
  Users
  ###
  createUser: (sessionToken, name, username, password) ->
    user = if @is_simulation then Users.findOne() else AuthN.getUserBySessionToken sessionToken
    throw new Meteor.Error(403, "You are not logged in") unless user?
    result = createUser name, username, password
    throw new Meteor.Error(500, "Unkown error creating a user") unless result?
    result

  updateUser: (sessionToken, userId, properties) ->
    user = if @is_simulation then Users.findOne() else AuthN.getUserBySessionToken sessionToken
    if not user?
      throw new Meteor.Error 403, "You are not authorized to update a user."
    if not user._id is userId
      throw new Meteor.Error 403, "You are not authorized to update this particular user (id: #{user._id})."
    if properties.username?
      existingUser = Users.findOne username: properties.username
      if existingUser? and existingUser._id is not userId
        throw new Meteor.Error 409, "Sorry, this username is unavailable!"

    result = updateUser userId, properties
    throw new Meteor.Error(500, "Unkown error updating a user") unless result?
    result

  deleteUser: (sessionToken, userId) ->
    user = if @is_simulation then Users.findOne() else AuthN.getUserBySessionToken sessionToken
    if not user?
      throw new Meteor.Error 403, "You are not authorized to delete a user."
    if not user._id is userId
      throw new Meteor.Error 403, "You are not authorized to delete this particular user (id: #{user._id})."

    result = deleteUser userId
    throw new Meteor.Error(500, "Unkown error deleting a user") unless result?
    result


  ###
  Authentication
  ###
  login: (username, password) ->
    return if @is_simulation
    sessionToken = AuthN.getSessionTokenForUsernamePassword username, password
    if not sessionToken?
      throw new Meteor.Error 401, "Invalid username and password combination"
    sessionToken

  logout: (sessionToken) ->
    return if @is_simulation
    result = AuthN.clearUserSessions sessionToken
    if not result?
      throw new Meteor.Error 412, "Unable to logout: session token not matching a user"
    result


  ###
  Tracking
  ###
  trackEvents: (sessionToken, evts) ->
    return if @is_simulation
    console.log "tracking", evts, "for", sessionToken
    user = if @is_simulation then Users.findOne() else AuthN.getUserBySessionToken sessionToken
    console.log user
    throw new Meteor.Error(403, "You are not logged in") unless user?
    console.log("authenticated")
    try
      # TODO don't use extend anymore once the data structure is settled upon,
      # it's a security hole!
      console.log("iterating")
      console.log(evts)
      _.each evts, (evt) ->
        console.log(evt)
        evt.userId = user._id
        console.log(user._id)
        eventId = TrackedEvents.insert evt
      return true
    catch e
      console.error "Could not create trackedEvent: ", e

    return false

  trackAnonymousEvents: (fingerprint, cookie, evts) ->
    return if @is_simulation
    console.log "tracking", evts, "for", fingerprint, cookie
    throw new Meteor.Error(403, "No fingerprint or cookie") unless fingerprint? and cookie?
    try
      # TODO don't use extend anymore once the data structure is settled upon,
      # it's a security hole!
      console.log(evts)
      _.each evts, (evt) ->
        evt.fingerprint = fingerprint
        evt.cookie = cookie
        eventId = TrackedEvents.insert evt
      return true
    catch e
      console.error "Could not create trackedEvent: ", e

    return false
