import 'package:hive/hive.dart';
import 'package:q2/storage/api_response_box.dart';

abstract class ApiRepositoryAbstract {
  Future<void> saveResponse(String id, String response);
  Future<ApiResponseBox?> loadResponse(String id);
}

// ignore: constant_identifier_names
const String APIBOX = "ApiBox";

class ApiRepository implements ApiRepositoryAbstract {
  static const int _cacheTimeout = 60 * 60 * 1000; // 1 hour

  final HiveInterface hive;

  ApiRepository({required this.hive});

  @override
  Future<ApiResponseBox?> loadResponse(String id) async {
    final box = await _openBox(APIBOX);
    ApiResponseBox? cachedResponse;
    if (box.isNotEmpty) {
      cachedResponse = box.values.firstWhere((element) => element.id == id);

      if (cachedResponse != null &&
          DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp <
              _cacheTimeout) {
        return cachedResponse;
      }
    }
    return null;
  }

  @override
  Future<void> saveResponse(String id, String response) async {
    final box = await _openBox(APIBOX);
    // Save new response to cache
    final newResponse = ApiResponseBox()
      ..id = id
      ..response = response
      ..timestamp = DateTime.now().millisecondsSinceEpoch;
    await box.add(newResponse);
  }

  Future<Box> _openBox(String type) async {
    try {
      final box = await hive.openBox(type);
      return box;
    } catch (e) {
      throw CacheException();
    }
  }
}

class CacheException {}
