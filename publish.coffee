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
    throw new Meteor.error(403, "You are not logged in") unless user?
    result = createUser name, username, password
    throw new Meteor.error(500, "Unkown error creating a user") unless result?
    result

  updateUser: (sessionToken, userId, properties) ->
    user = if @is_simulation then Users.findOne() else AuthN.getUserBySessionToken sessionToken
    if not user?
      throw new Meteor.error 403, "You are not authorized to update a user."
    if not user._id is userId
      throw new Meteor.error 403, "You are not authorized to update this particular user (id: #{user._id})."
    if properties.username?
      existingUser = Users.findOne username: properties.username
      if existingUser? and existingUser._id is not userId
        throw new Meteor.error 409, "Sorry, this username is unavailable!"

    result = updateUser userId, properties
    throw new Meteor.error(500, "Unkown error updating a user") unless result?
    result

  deleteUser: (sessionToken, userId) ->
    user = if @is_simulation then Users.findOne() else AuthN.getUserBySessionToken sessionToken
    if not user?
      throw new Meteor.error 403, "You are not authorized to delete a user."
    if not user._id is userId
      throw new Meteor.error 403, "You are not authorized to delete this particular user (id: #{user._id})."

    result = deleteUser userId
    throw new Meteor.error(500, "Unkown error deleting a user") unless result?
    result


  ###
  Authentication
  ###
  login: (username, password) ->
    console.log this
    return if @is_simulation
    sessionToken = AuthN.getSessionTokenForUsernamePassword username, password
    if not sessionToken?
      throw new Meteor.error 401, "Invalid username and password combination"
    sessionToken

  logout: (sessionToken) ->
    return if @is_simulation
    result = AuthN.clearUserSessions sessionToken
    if not result?
      throw new Meteor.error 412, "Unable to logout: session token not matching a user"
    result
