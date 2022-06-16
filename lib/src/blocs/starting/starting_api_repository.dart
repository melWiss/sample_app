import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sample_app/src/blocs/starting/starting_cache_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_exception.dart';
import 'package:sample_app/src/consts.dart';
import 'package:sample_app/src/models/location.dart';

/// This class helps to retrieve the list of locations from the rest API.
class StartingPointApiRepository {
  /// this function retrieves the list of locations by using a keyword string.
  static Future<List<Location>> getLocations(String keyword) async {
    try {
      var response = await http.get(Uri.parse("$apiUrl$keyword"));
      Map data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      List locationsData = data["locations"] as List;
      List<Location> locations = locationsData
          .map<Location>(
            (e) => Location.fromMap(e),
          )
          .toList();
      StartingPointCacheRepository.cacheLocations(locations);
      return locations;
    } on SocketException catch (e) {
      List<Location> cachedLocations =
          await StartingPointCacheRepository.getCachedLocations();
      throw StartingPointException(
        cachedLocations: cachedLocations
            .where((element) =>
                element.name?.toUpperCase().contains(keyword.toUpperCase()) ??
                false)
            .toList(),
        error: e.message,
      );
    }
  }
}
