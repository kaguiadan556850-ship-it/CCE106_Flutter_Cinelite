import '../../../domain/entities/booking_record.dart';

/// Abstract local-storage contract for bookings. There are two
/// implementations because sqflite does NOT work on Flutter Web (it
/// has no web backend and the call just hangs instead of throwing):
///
/// - [SqfliteBookingLocalDataSource] — real SQLite, used on
///   Android/iOS/desktop.
/// - [WebBookingLocalDataSource] — shared_preferences-backed JSON
///   storage, used on web.
///
/// main.dart picks the right one at startup based on `kIsWeb`, and
/// everything above this (BookingRepositoryImpl and up) only ever
/// depends on this interface.
abstract class BookingLocalDataSource {
  Future<void> insert(BookingRecord booking);
  Future<void> markSynced(String id);
  Future<List<BookingRecord>> getAll({String? userId});
  Future<List<BookingRecord>> getUnsynced();
}
