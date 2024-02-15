import 'package:flutter_test/flutter_test.dart';
import 'package:q2/network/person_list_network_service.dart';

void main() {
  group('Test fetch', () {
    test('fetch success', () async {
      final service = PersonListNetworkService();
      service.fetch().then(expectAsync1((value) {
        expect(value.length, greaterThan(0));
      }), onError: (err) {
        fail('error !');
      });
    });
  });
}
