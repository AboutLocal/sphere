
bootstrap = () ->
  marco = Users.findOne(username: "marco")

  if not marco?
    console.log("Creating user 'marco'")
    marco = Users.findOne id: UserManager.create("Marco Süß", "marco", "password")
