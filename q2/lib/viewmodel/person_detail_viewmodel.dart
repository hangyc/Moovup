import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:q2/mvvm/viewmodel.dart';
import 'package:q2/model/person.dart';

class PersonDetailViewModel extends EventViewModel {
  PersonDetailViewModel(this._person);

  final Person _person;

  get mapOptions {
    LatLng? loc = latLng();
    if (loc != null) {
      return MapOptions(initialCenter: loc, initialZoom: 14.0);
    } else {
      return const MapOptions(initialZoom: 14.0);
    }
  }

  Person get person => _person;

  LatLng? latLng() {
    if (_person.location.latitude != null &&
        _person.location.longitude != null) {
      return LatLng(_person.location.latitude!, _person.location.longitude!);
    } else {
      return null;
    }
  }
}
