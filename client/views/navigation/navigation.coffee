Template.navigation.events =
  "click .login": (evt) ->
    loginButton = $(evt.target)
    dropdown = $("#dropdown-login-form")
    #log loginButton.offset()
    #log dropdown.offset()
    if dropdown.hasClass "visible"
      dropdown.removeClass "visible"
    else
      dropdown.addClass "visible"
      dropdown.offset left: loginButton.offset().left - dropdown.width()
      dropdown.find("input").first().focus()
