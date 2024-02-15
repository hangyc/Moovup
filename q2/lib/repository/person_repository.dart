import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:q2/network/person_list_network_service.dart';

import 'package:q2/model/person.dart';
import 'package:q2/repository/api_repository.dart';
import 'package:q2/storage/api_response_box.dart';

abstract class PersonRepositoryAbstract {
  List<Person> get persons;
  Future<List<Person>> fetchPersons();
}

class PersonRepository extends ApiRepository
    implements PersonRepositoryAbstract {
  static const String _cacheId = "person_key";
  final PersonListNetworkServiceable service;

  @override
  List<Person> persons = [];

  PersonRepository(this.service, {required super.hive});

  @override
  Future<List<Person>> fetchPersons() async {
    if (persons.isNotEmpty) {
      // in memory cache
      return Future.value(persons);
    }
    final hasConnected = await InternetConnectionChecker().hasConnection;
    if (hasConnected) {
      final List<Person> response = await _fetchPersons();
      persons = response;
      String jsonString = json.encode(response);
      await saveResponse(_cacheId, jsonString);
      return Future.value(response);
    } else {
      return _fetchPersonsLocally();
    }
  }

  Future<List<Person>> _fetchPersons() async {
    return service.fetch();
  }

  // ignore: invalid_visibility_annotation
  @visibleForTesting
  Future<List<Person>> _fetchPersonsLocally() async {
    ApiResponseBox? cachedResponse = await loadResponse(_cacheId);

    if (cachedResponse != null) {
      Iterable l = json.decode(cachedResponse.response);
      List<Person> results =
          List<Person>.from(l.map((model) => Person.fromJson(model)));
      return Future.value(results);
    }
    return Future.error('No cache data');
  }
}

// For unit test only
extension PersonRepositoryStub on PersonRepository {
  // ignore: non_constant_identifier_names
  Future<List<Person>> public_fetchPersons() async {
    return _fetchPersons();
  }

  // ignore: non_constant_identifier_names
  Future<List<Person>> public_fetchPersonsLocally() async {
    return _fetchPersonsLocally();
  }
}
