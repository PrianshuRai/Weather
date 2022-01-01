import 'package:geolocator/geolocator.dart';

Future _getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print(position);
}
