import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:q2/repository/person_repository.dart';

import 'mock/mock_person_list_service.dart';

void main() {
  setUp(() async {
    // Hive.init(Directory.current.path);
    // Hive.registerAdapter(ApiResponseBoxAdapter());

    // Box box = await Hive.openBox("APIBOX");
    // box.clear();
  });

  group('Test start, _fetchPersons', () {
    test('_fetchPersons success', () async {
      MockPersonListNetworkService service = MockPersonListNetworkService();
      final repository = PersonRepository(service, hive: Hive);
      repository.public_fetchPersons().then(expectAsync1((value) {
        expect(value.length, greaterThan(0));
      }), onError: (err) {
        fail('error !');
      });
    });

    // test('save', () async {
    //   MockPersonListNetworkService service = MockPersonListNetworkService();
    //   final repository = PersonRepository(service, hive: Hive);

    //   repository.saveResponse("test", service.mockResponse);

    //   // Box box = await Hive.openBox("APIBOX");
    //   // expect(box.isNotEmpty, true);
    // });

    // test('_fetchPersonsLocally success', () async {
    //   MockPersonListNetworkService service = MockPersonListNetworkService();
    //   final repository = PersonRepository(service, hive: Hive);

    //   repository.public_fetchPersonsLocally().then(expectAsync1((value) {
    //     expect(value.length, greaterThan(0));
    //   }), onError: (err) {
    //     fail('error !');
    //   });
    // });
  });
}
