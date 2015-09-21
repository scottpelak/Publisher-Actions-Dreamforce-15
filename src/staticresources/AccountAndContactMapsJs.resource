// Geocoder and Map Options
geocoder = new google.maps.Geocoder();

// Addresses
var Address = function(addressType, id, name, street, city, state, zipCode, latitude, longitude){
    this.addressType = addressType;
    this.id = id;
    this.name = name;
    this.street = street;
    this.city = city;
    this.state = state;
    this.zipCode = zipCode;
    var lat = Number(latitude);
    var lng = Number(longitude);
    if(!isNaN(lat) && !isNaN(lng) && !(lat == 0 && lng == 0))
    	this.latLng = new google.maps.LatLng(lat, lng);
}

Address.prototype.getAddress = function(){
    var a = '';
    a += (this.street) ? this.street + ',' : '';
    a += (this.city) ? ' ' + this.city + ',' : '';
    a += (this.state) ? ' ' + this.state : '';
    a = a.substr(a.length - 1) == ',' ? a.substr(0, a.length - 1) : a;
    a += (this.zipCode) ? ' ' + this.zipCode : '';
    return a;
}

Address.prototype.getName = function(){
    return this.name;
}

Address.prototype.setLatLng = function(latLng){
	this.latLng = latLng;
}

Address.prototype.getIsValidAddress = function(){
    return (this.getAddress()) ? true : false;
}

Address.prototype.getIsValid = function(){
    return (this.latLng) ? true : false;
}

Address.prototype.getLatLng = function(){
    return this.latLng;
}

var addresses = {
	add: function(addressType, street, city, state, postalCode, latitude, longitude){
		this[addressType] = new Address(
			addressType, street, city, state, postalCode, latitude, longitude
		);
	}
};

function setMap(addressType){
    removeAllActiveClass();
	var address = addresses[addressType];
    var setMapResult = false;
	if(address.getIsValid()){
        addActiveClass(addressType);
    	console.log('LatLng found');
    	var mapOptions = {
            zoom: 15,
            center: address.getLatLng()
        };
        map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
        var marker = new google.maps.Marker({
            map: map,
            position: address.getLatLng()
        });
        setMapResult = true;
    } else if(address.getIsValidAddress()){
        addActiveClass(addressType);
    	geocoder.geocode( {'address': address.getAddress()}, function(results, status){
            if(status == google.maps.GeocoderStatus.OK){
            	address.setLatLng(results[0].geometry.location);
                console.log(addressType + ' new LatLng:');
                console.log(address.getLatLng());
                var mapOptions = {
	                zoom: 15,
	                center: address.getLatLng()
	            };
                map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
                
                var infoWindow = new google.maps.InfoWindow({
                    content: '<div id="content"><div id="siteNotice"></div><h1>' + address.getName() + '</h1><p>' + address.getAddress() + '</p></div>'
                });

                var marker = new google.maps.Marker({
                    map: map,
                    position: address.getLatLng(),
                    title: address.getName()
                });

                google.maps.event.addListener(marker, 'click', function(){
                    infoWindow.open(map, marker);
                });

                var latitude = address.getLatLng().G;
                var longitude = address.getLatLng().K;


                AddressLocationSetter.updateLocation(
                    address.id, 
                    addressType, 
                    latitude,
                    longitude,
                    function(event, result){
                        console.log('updateLocation event:');
                        console.log(event);
                        console.log('updateLocation result:');
                        console.log(result);
                    }
                );
            } else {
                console.log(addressType + ' Geocode was not successful for the following reason: ' + status);
                var m = document.getElementById('map-canvas');
                m.innerHTML = 'No valid ' + addressType + ' Address found.  Error: ' + status;
                m.style.backgroundColor = 'inherit';   
            }
        }); 

	} else {
        var m = document.getElementById('map-canvas');
        m.innerHTML = 'No valid ' + addressType + ' Address found.';
        m.style.backgroundColor = 'inherit';
        removeActiveClass(addressType);
    }
    console.log('setMapResult: ' + setMapResult);
}

function addActiveClass(elementId){
    document.getElementById(elementId).classList.add('btn-active');
}

function removeActiveClass(elementId){
    removeElementActiveClass(document.getElementById(elementId));
}

function removeElementActiveClass(e){
    e.classList.remove('btn-active');
}

function removeAllActiveClass(){
    var allActiveList = document.getElementsByClassName('btn-active');
    console.log('allActiveListLength: ' + allActiveList.length);
    for(var i = 0; i < allActiveList.length; i ++){
        removeElementActiveClass(allActiveList[i]);
    }
}

console.log('loaded...'); 