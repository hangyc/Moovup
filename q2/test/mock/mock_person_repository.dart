import 'dart:convert';

import 'package:q2/model/person.dart';
import 'package:q2/repository/person_repository.dart';

import 'mock_person_list_service.dart';

class MockPersonRepository implements PersonRepositoryAbstract {
  @override
  List<Person> get persons {
    Iterable l = json.decode(MockPersonListNetworkService().mockResponse);
    List<Person> results =
        List<Person>.from(l.map((model) => Person.fromJson(model)));
    return results;
  }

  @override
  Future<List<Person>> fetchPersons() {
    return Future.value(persons);
  }
}
