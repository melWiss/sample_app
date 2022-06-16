import 'package:sample_app/src/models/location.dart';

/// an exception that occures when there's an error during api call.
/// it returns the error description and a list of cached locations.
class StartingPointException implements Exception {
  final String error;
  final List<Location> cachedLocations;
  StartingPointException({required this.cachedLocations, required this.error});
}
