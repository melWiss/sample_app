import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample_app/src/models/location.dart';

class StartingPointCacheRepository {
  static File? _db;

  static Future initDb() async {
    if (_db == null) {
      var dir = await getApplicationSupportDirectory();
      _db = File(join(dir.path, "db.json"));
      if (!(_db?.existsSync() ?? false)) {
        _db!.createSync();
        _db!.writeAsStringSync(jsonEncode([]));
      }
    }
  }

  static Future<List<Location>> getCachedLocations([String? keyword]) async {
    if (_db != null) {
      var data = jsonDecode(_db!.readAsStringSync()) as List;
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

  static Future<bool> cacheLocations(List<Location> locations) async {
    try {
      Set<Location> uniqueLocations = {};
      List<Location> cachedLocations = await getCachedLocations();
      uniqueLocations.addAll(cachedLocations);
      uniqueLocations.addAll(locations);
      _db!.writeAsStringSync(jsonEncode(uniqueLocations.toList()));
      return true;
    } catch (e) {
      return false;
    }
  }
}
