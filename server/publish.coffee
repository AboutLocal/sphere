Meteor.publish "publishedUsers", (sessionToken) ->
  sessionUser = Auth.getUserBySessionToken(sessionToken)
  sessionUserID = if sessionUser then sessionUser._id else 0
  users = Users.find({}, {fields: {username: false, password_hash: false}})

  @publishModifiedCursor users, "users", (user) ->
    user.__is_session_user = sessionUserID is user._id
    user


#Extension to Meteor to allow modifications to documents when publishing
_.extend Meteor._LivedataSubscription.prototype,
  publishModifiedCursor: (cursor, name, map_callback) ->
    self = this
    collection = name || cursor.collection_name

    observe_handle = cursor.observe
      added: (obj) ->
        obj = map_callback.call self, obj
        self.set collection, obj._id, obj
        self.flush()
      changed: (obj, old_idx, old_obj) ->
        set = {}
        obj = map_callback.call self, obj
        _.each obj, (v, k) ->
          if !_.isEqual v, old_obj[k]
            set[k] = v

        self.set collection, obj._id, set
        dead_keys = _.difference _.keys(old_obj), _.keys(obj)
        self.unset collection, obj._id, dead_keys
        self.flush()
      removed: (old_obj, old_idx) ->
        self.unset collection, old_obj._id, _.keys(old_obj)
        self.flush()

    self.complete()
    self.flush()

    self.onStop _.bind(observe_handle.stop, observe_handle)
