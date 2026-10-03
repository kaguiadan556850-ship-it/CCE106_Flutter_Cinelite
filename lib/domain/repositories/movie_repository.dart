import '../entities/movie.dart';

/// Domain-layer contract. The data layer provides the implementation;
/// the presentation layer (ViewModels) only ever depends on this
/// abstraction, never on Firestore/mock details directly.
abstract class MovieRepository {
  Future<List<Movie>> getNowShowing();
  Future<List<Movie>> getComingSoon();
}
