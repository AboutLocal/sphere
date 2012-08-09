Template.contact.invokeAfterLoad = ->
  Meteor.defer () ->
    mapOptions = {
    center: new google.maps.LatLng(52.53180, 13.42799)
    zoom: 16
    mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map( $(".map_canvas")[0], mapOptions )
    marker = new google.maps.Marker( {map: map, position: new google.maps.LatLng(52.53200, 13.42768), icon: '/img/contact/maps-marker.png'} )
    infowindow = new google.maps.InfoWindow( {content: "<strong>aboutLocal GmbH</strong><br>Greifswalder Str. 212<br>10405 Berlin"} )
    google.maps.event.addListener(marker, "click", () ->
      infowindow.open(map,marker)
    )
    #infowindow.open(map,marker)
    
    

