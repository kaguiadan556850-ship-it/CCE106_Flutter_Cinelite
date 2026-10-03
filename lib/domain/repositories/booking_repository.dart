import '../entities/booking_record.dart';

abstract class BookingRepository {
  /// Persists locally (sqflite) immediately, then attempts a best-effort
  /// remote sync (Firestore). Never throws if the remote sync fails —
  /// the local save is the source of truth for the device.
  Future<void> saveBooking(BookingRecord booking);

  /// Local booking history for the "My Bookings" screen, newest first.
  Future<List<BookingRecord>> getHistory({String? userId});

  /// Retries syncing any local bookings that failed to reach Firestore.
  Future<void> retryPendingSync();
}
