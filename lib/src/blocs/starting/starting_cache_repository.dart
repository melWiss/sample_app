import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample_app/src/models/location.dart';

/// This class helps to retrieve the list of locations from the cached data.
class StartingPointCacheRepository {
  /// this file is a reference to the file where we cache the list of
  /// fetched locations.
  static File? _db;

  /// this method initialize our database, it should be called when the app
  /// starts.
  static Future<void> initDb() async {
    if (_db == null) {
      var dir = await getApplicationSupportDirectory();
      _db = File(join(dir.path, "db.json"));
      if (!(_db?.existsSync() ?? false)) {
        _db!.createSync();
        _db!.writeAsStringSync(jsonEncode([]));
      }
    }
  }

  /// get cached locations from the database with/without a keyword.
  static Future<List<Location>> getCachedLocations([String? keyword]) async {
    if (_db != null) {
      var data = jsonDecode(utf8.decode(_db!.readAsBytesSync())) as List;
      List<Location> locations = data
          .map<Location>(
            (e) => Location.fromMap(e),
          )
          .toList();
      if (keyword != null) {
        locations = locations
            .where((element) =>
                (element.name?.toUpperCase().contains(keyword.toUpperCase()) ??
                    false))
            .toList();
      }
      return locations;
    } else {
      throw "_db is null";
    }
  }

  /// cache a list of locations inside the database.
  static Future<bool> cacheLocations(List<Location> locations) async {
    try {
      Set<Location> uniqueLocations = {};
      List<Location> cachedLocations = await getCachedLocations();
      uniqueLocations.addAll(cachedLocations);
      uniqueLocations.addAll(locations);
      _db!.writeAsBytesSync(utf8.encode(jsonEncode(uniqueLocations.toList())));
      return true;
    } catch (e) {
      return false;
    }
  }
}
