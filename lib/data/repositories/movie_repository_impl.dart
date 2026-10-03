import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/mock/mock_catalog_data_source.dart';

/// Catalog data currently comes from the local mock data source only.
/// Swap the body of these methods for a FirestoreCatalogDataSource call
/// if/when you seed a `movies` collection in Firestore — the ViewModel
/// layer above this won't need to change at all, that's the point of
/// the repository pattern.
class MovieRepositoryImpl implements MovieRepository {
  @override
  Future<List<Movie>> getNowShowing() async => MockData.nowShowing();

  @override
  Future<List<Movie>> getComingSoon() async => MockData.comingSoon();
}
