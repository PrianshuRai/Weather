@JS('navigator.geolocation') // navigator.geolocation namespace
library jslocation; // library name can be whatever you want

import "package:js/js.dart";

@JS('getCurrentPosition') // Accessing method getCurrentPosition from Geolocation API
external void getCurrentPosition(Function success(dynamic pos));

@JS()
@anonymous
class GeolocationCoordinates {
  external factory GeolocationCoordinates({double latitude, double longitude});

  external double get longitude;

  external double get latitude;
}

@JS()
@anonymous
class GeolocationPosition {
  external factory GeolocationPosition({GeolocationCoordinates coords});

  external GeolocationCoordinates get coords;
}
