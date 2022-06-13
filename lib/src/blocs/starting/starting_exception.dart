import 'package:sample_app/src/models/location.dart';

class StartingPointException implements Exception {
  final String error;
  final List<Location> cachedLocations;
  StartingPointException({required this.cachedLocations, required this.error});
}
