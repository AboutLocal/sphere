(->
  isLoggingIn = false

  spinner = new Spinner
    lines: 9
    length: 0
    width: 2
    radius: 4
    rotate: 0
    color: "#fff"
    speed: 1.0
    trail: 60
    shadow: false
    hwaccel: true
    className: "spinner"
    zIndex: 2e9
    top: "auto"
    left: "auto"

  Template.loginForm.events =
    "submit form": (evt) ->
      evt.preventDefault()

      return if isLoggingIn

      form = evt.target
      username = form[0].value
      password = form[1].value
      rememberMe = form[2].value

      #console.log evt

      hasError = false

      if not username
        form[0].className = "error"
        hasError = true
      if not password
        form[1].className = "error"
        hasError = true

      return if hasError

      isLoggingIn = true

      future = Rpc.login username, password

      button = $ "button", form
      oldText = button.text()
      button.text("Bitte warten…")

      spinner.spin()
      button.prepend spinner.el

      errorElement = Sizzle("p", form)[0]
      errorElement.style.display = "none"

      future.done ->
        button.text("Fertig!")
        setTimeout (() -> button.text(oldText)), 200
        $(form).removeClass "visible"

      future.fail (error) ->
        button.text(oldText)
        errorElement.innerText = error.reason
        errorElement.style.display = "block"

      future.always ->
        spinner.stop()
        isLoggingIn = false
)()
