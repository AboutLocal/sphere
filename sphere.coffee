
root = global ? window

if root.Meteor.is_client

  root.Template.hello.greeting = ->
    "Welcome to sphere."

  root.Template.hello.events =
    'click input' : ->
      createPieChart "#pie", 75
      # template data, if any, is available in 'this'
      if (typeof console != 'undefined')
        console.log("You pressed the button")


  osName = "unkown"
  if navigator.appVersion.indexOf("Win") != -1
    osName = "Windows"
  if navigator.appVersion.indexOf("Mac") != -1
    osName = "MacOS"
  if navigator.appVersion.indexOf("X11") != -1
    osName = "UNIX"
  if navigator.appVersion.indexOf("Linux") != -1
    osName = "Linux"

  Meteor.startup () ->
    $(document.body).addClass osName.toLowerCase()

  createPieChart = (containerSelector, percentValue) ->

    # config
    w = 450
    h = 300
    r = 43
    ir = 0
    textOffset = 14
    tweenDuration = 250

    innerCircleRadius = r - 8
    strokeWidth = 1

    # data objects
    #lines, valueLabels, nameLabels
    pieData = []
    oldPieData = []
    filteredPieData = []

    # pie helper
    pie = d3.layout.pie().value (d) ->
      d.value

    # arc helper
    arc = d3.svg.arc()
    arc.startAngle (d) -> d.startAngle
    arc.endAngle   (d) -> d.endAngle
    arc.innerRadius ir
    arc.outerRadius innerCircleRadius - strokeWidth

    # small arc helper
    smallArc = d3.svg.arc()
    smallArc.startAngle (d) -> d.startAngle
    smallArc.endAngle   (d) -> d.endAngle
    smallArc.innerRadius ir
    smallArc.outerRadius innerCircleRadius - strokeWidth * 2

    vis = d3.select(containerSelector).append("svg:svg").attr("width", w).attr("height", h)

    arcGroup = vis.append("svg:g")
      .attr("class", "arc")
      .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")")

    greenGradient = arcGroup.append("svg:linearGradient")
      .attr("id", "greenGradient")
      .attr("x1", "0%")
      .attr("x2", "0%")
      .attr("y1", "0%")
      .attr("y2", "100%")

    greenGradient.append("svg:stop")
      .attr("offset", "0%")
      .attr("style", "stop-color:#84c917;stop-opacity:1")

    greenGradient.append("svg:stop")
      .attr("offset", "100%")
      .attr("style", "stop-color:#6fa817;stop-opacity:1")

    reliefGradient = arcGroup.append("svg:linearGradient")
      .attr("id", "reliefGradient")
      .attr("x1", "0%")
      .attr("x2", "0%")
      .attr("y1", "0%")
      .attr("y2", "100%")

    reliefGradient.append("svg:stop")
      .attr("offset", "0%")
      .attr("style", "stop-color:#9bd343;stop-opacity:1")

    reliefGradient.append("svg:stop")
      .attr("offset", "100%")
      .attr("style", "stop-color:#9bd343;stop-opacity:0")

    labelGroup = vis.append("svg:g")
      .attr("class", "labelGroup")
      .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")")

    centerGroup = vis.append("svg:g")
      .attr("class", "centerGroup")
      .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")")

    outerCircle = arcGroup.append("svg:circle")
      .attr("fill", "#eaebeb")
      .attr("r", r)

    innerCircle = arcGroup.append("svg:circle")
      .attr("fill", "#ced3d7")
      .attr("r", innerCircleRadius)

    endRadians = percentValue*3.6/180*Math.PI

    arcGroup.append("svg:path")
      .attr("fill", "url(#greenGradient)")
      .attr("stroke", "#72ad16")
      .attr("d", arc({startAngle: 0, endAngle: endRadians}))

    arcGroup.append("svg:path")
      .attr("fill", "rgba(0,0,0,0)")
      .attr("stroke", "url(#reliefGradient)")
      .attr("d", smallArc({startAngle: 0, endAngle: endRadians}))





if root.Meteor.is_server

  ###
  require = root.__meteor_bootstrap__.require
  path = require "path"
  fs = require "fs"

  nibPath = "node_modules/nib"

  base = path.resolve "."
  if base == "/"
    base = path.dirname global.require.main.filename

  publicPath = path.resolve base + "/public/" + nibPath
  staticPath = path.resolve base + "/static/" + nibPath

  if path.existsSync publicPath
    nib = require publicPath
  else if path.existsSync staticPath
    nib = require staticPath
  else
    console.log "node_modules not found"

  console.log nib
  stylus = require "stylus"
  stylus().use nib()
  ###

  Meteor.startup ->
    # code to run on server at startup
    console.log("Sphere is running")
