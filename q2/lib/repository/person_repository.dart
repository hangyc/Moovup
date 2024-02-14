import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:q2/network/person_request.dart';

import 'package:q2/model/person.dart';
import 'package:q2/storage/api_response_box.dart';

class PersonRepository {
  static const String _boxname = "apiResponses";
  static const String _cacheId = "person_key";

  Future<List<Person>> fetchPersons() async {
    final hasConnected = await InternetConnectionChecker().hasConnection;
    if (hasConnected) {
      final List<Person> response = await _fetchPersons();
      String jsonString = json.encode(response);
      // save jsonString to
      save(jsonString);
      return Future.value(response);
    } else {
      return _fetchPersonsLocally();
    }
  }

  Future<List<Person>> _fetchPersons() async {
    return PersonRequest().fetch();
  }

  Future<List<Person>> _fetchPersonsLocally() async {
    final box = await Hive.openBox(_boxname);
    // box.clear();

    ApiResponseBox? cachedResponse;
    if (box.isNotEmpty) {
      cachedResponse =
          box.values.firstWhere((element) => element.id == _cacheId);
    }
    box.close();

    if (cachedResponse != null) {
      Iterable l = json.decode(cachedResponse.response);
      List<Person> results =
          List<Person>.from(l.map((model) => Person.fromJson(model)));
      return Future.value(results);
    }
    return Future.error('No cache data');
  }

  void save(String response) async {
    final box = await Hive.openBox(_boxname);
    // Save new response to cache
    final newResponse = ApiResponseBox()
      ..id = _cacheId
      ..response = response
      ..timestamp = DateTime.now().millisecondsSinceEpoch;
    await box.add(newResponse);

    box.close();
  }
}
