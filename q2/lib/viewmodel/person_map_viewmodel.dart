import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:q2/extension/extension.dart';
import 'package:q2/model/person.dart';

import 'package:q2/viewmodel/person_viewmodel.dart';

class PersonMapViewModel extends PersonViewModel {
  PersonMapViewModel(super.repository);

  MapOptions mapOptions = const MapOptions(initialZoom: 14.0);

  @override
  void onDataLoad(List<Person> data) {
    List<Person> filtered =
        data.where((element) => element.location.getLatLng() != null).toList();

    LatLng? loc = filtered.first.location.getLatLng();
    if (loc != null) {
      mapOptions = MapOptions(initialCenter: loc, initialZoom: 14.0);
    }
    super.onDataLoad(filtered);
  }
}
