function initMap(){
    const location = document.getElementById("institution_location");
    const home = JSON.parse(location.value.replace("(", "[").replace(")", "]"));
    const pos = new google.maps.LatLng(home[0], home[1])
  
    const map = new google.maps.Map(document.getElementById('map'), {
      center: pos,
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.SATELLITE
    });
  
    const marker = new google.maps.Marker({
      position: pos,
      draggable: true,
      map: map
    });
  
    marker.addListener("dragend", function(arg) {
      location.value = arg.latLng.toString();
    });
}

document.addEventListener('turbo:load', () => {
  initMap();
});
