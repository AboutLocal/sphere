Template.navigation.events =
  "click .login": ->
    dropdown = $("#dropdown-login-form")
    if dropdown.hasClass "visible"
      dropdown.removeClass "visible"
    else
      dropdown.addClass "visible"
      dropdown.find("input").first().focus()
