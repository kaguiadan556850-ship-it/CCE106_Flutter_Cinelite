import '../../domain/entities/cinema.dart';
import '../../domain/repositories/cinema_repository.dart';
import '../datasources/mock/mock_catalog_data_source.dart';

class CinemaRepositoryImpl implements CinemaRepository {
  @override
  Future<List<Cinema>> getCinemas() async => MockData.cinemas;

  @override
  Future<List<Cinema>> search(String query) async {
    final q = query.toLowerCase();
    return MockData.cinemas
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.address.toLowerCase().contains(q))
        .toList();
  }
}
