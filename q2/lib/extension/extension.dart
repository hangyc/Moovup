import 'package:latlong2/latlong.dart';

import 'package:q2/model/location.dart';
import 'package:q2/model/person.dart';

extension LocationHelper on Location {
  LatLng? getLatLng() {
    if (latitude != null && longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    return null;
  }

  String? getLagLngInfo() {
    if (latitude != null && longitude != null) {
      return "$latitude, $longitude";
    }
    return null;
  }
}

extension PersonHelper on Person {
  get displayName => "${name.first}, ${name.last}";
}
