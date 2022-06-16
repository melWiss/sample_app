import 'package:rxdart/rxdart.dart';
import 'package:sample_app/src/blocs/starting/starting_api_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_cache_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_exception.dart';
import 'package:sample_app/src/models/models.dart';

/// StartingPointBloc class for Locations state management.
class StartingPointBloc {
  /// the controller of the list of locations state.
  final BehaviorSubject<List<Location>?> _controller =
      BehaviorSubject<List<Location>?>();

  /// get the stream of list of locations.
  Stream<List<Location>?> get stream => _controller.stream;

  /// get the current list of locations.
  List<Location>? get current => _controller.value;

  /// shows a circular progress indicator.
  showCircularProgressIndicator() {
    _controller.add(null);
  }

  /// it initialize the list of locations from the cache.
  Future<void> initLocations() async {
    await StartingPointCacheRepository.initDb();
    List<Location> locations =
        await StartingPointCacheRepository.getCachedLocations();
    _controller.add(locations);
  }

  /// search for locations from the API using a keyword.
  searchLocation(String keyword) async {
    try {
      List<Location> locations =
          await StartingPointApiRepository.getLocations(keyword);
      _controller.add(locations);
    } on StartingPointException catch (e) {
      _controller.addError(e);
    }
  }
}

/// an object of StartingPointBloc class.
StartingPointBloc startingPointBloc = StartingPointBloc();
