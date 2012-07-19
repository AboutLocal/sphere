
Users = new Meteor.Collection "users"

class UserManager

  @create = (name, username, password) ->

    return unless Meteor.is_server

    hashed = AuthN.generatePasswordHash password
    now = Date.now()
    try
      userId = Users.insert
        created: now
        modified: now
        name: name
        username: username
        passwordHash: hashed

      return true
    catch e
      console.error "Could not create user: ", e

    return false


  @update = (userId, properties) ->

    set = modified: Date.now()

    if Meteor.is_server and properties.password?
      set.passwordHash = AuthN.generatePasswordHash properties.password

    set.name = properties.name if properties.name?
    set.username = properties.username if properties.username?

    if _.size set
      try
        super userId, $set: set
        return userId
      catch e
        console.error "Could not update user", e

    return false


  @delete = (userId) ->

    try
      Users.remove(_id: userId)
      return userId
    catch e
      console.error "Could not delete user", e

    return false
