import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:collection/collection.dart';

import 'package:q2/extension/extension.dart';
import 'package:q2/model/person.dart';

import 'package:q2/viewmodel/person_map_viewmodel.dart';

import 'mock/mock_person_repository.dart';

void main() {
  test('test filter person not have valid location', () {
    final repository = MockPersonRepository();
    PersonMapViewModel viewModel = PersonMapViewModel(repository);

    List<Person> persons = viewModel.handleData(repository.persons);
    List<LatLng?> lagLngs = persons.map((e) => e.location.getLatLng()).toList();
    // .whereNotNull()
    // .toList();

    expect(persons.length, lagLngs.length);
  });
}
