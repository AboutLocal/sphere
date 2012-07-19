
Meteor.startup ->
  root.AuthN = AuthNManagerFactory.buildManager "]p-I4NS-MZVCh{1Vl@<hä/),.xpjRYä+",
    usernameField: "username"

  Meteor.default_server.method_handlers["/users/insert"] = () ->
  Meteor.default_server.method_handlers["/users/update"] = () ->
  Meteor.default_server.method_handlers["/users/remove"] = () ->

  bootstrap()
