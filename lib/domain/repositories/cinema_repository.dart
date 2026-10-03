import '../entities/cinema.dart';

abstract class CinemaRepository {
  Future<List<Cinema>> getCinemas();
  Future<List<Cinema>> search(String query);
}
