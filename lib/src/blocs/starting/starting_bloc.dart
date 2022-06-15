import 'package:rxdart/rxdart.dart';
import 'package:sample_app/src/blocs/starting/starting_api_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_cache_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_exception.dart';
import 'package:sample_app/src/models/models.dart';

class StartingPointBloc {
  final BehaviorSubject<List<Location>> _controller =
      BehaviorSubject<List<Location>>();

  Stream<List<Location>> get stream => _controller.stream;
  List<Location> get current => _controller.value;

  Future<void> initLocations() async {
    await StartingPointCacheRepository.initDb();
    List<Location> locations =
        await StartingPointCacheRepository.getCachedLocations();
    _controller.add(locations);
  }

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

StartingPointBloc startingPointBloc = StartingPointBloc();
