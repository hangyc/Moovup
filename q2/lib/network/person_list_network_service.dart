import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:q2/model/person.dart';

abstract class PersonListNetworkServiceable {
  Future<List<Person>> fetch();
}

class PersonListNetworkService implements PersonListNetworkServiceable {
  static const String url =
      "https://api.json-generator.com/templates/-xdNcNKYtTFG/data";
  static const String token = "b2atclr0nk1po45amg305meheqf4xrjt9a1bo410";

  @override
  Future<List<Person>> fetch() async {
    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = json.decode(response.body);
      List<Person> results =
          List<Person>.from(l.map((model) => Person.fromJson(model)));
      return Future.value(results);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return Future.error('Failed to load data');
    }
  }
}
