import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sample_app/src/blocs/starting/starting_cache_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_exception.dart';
import 'package:sample_app/src/consts.dart';
import 'package:sample_app/src/models/location.dart';

class StartingPointApiRepository {
  static Future<List<Location>> getLocations(String keyword) async {
    try {
      var response = await http.get(Uri.parse("$apiUrl$keyword"));
      Map data = jsonDecode(response.body) as Map;
      List locationsData = data["locations"] as List;
      List<Location> locations = locationsData
          .map<Location>(
            (e) => Location.fromMap(e),
          )
          .toList();
      StartingPointCacheRepository.cacheLocations(locations);
      return locations;
    } on SocketException catch (e) {
      throw StartingPointException(
        cachedLocations:
            await StartingPointCacheRepository.getCachedLocations(),
        error: e.message,
      );
    }
  }
}
