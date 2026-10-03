import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/booking_record.dart';
import '../../domain/repositories/booking_repository.dart';

/// Backs the "My Bookings" screen — proof that bookings really do
/// persist locally (sqflite on Android/iOS/desktop, shared_preferences
/// on web — see data/datasources/local/) and shows sync status per row
/// for the Firestore side.
class BookingHistoryViewModel extends ChangeNotifier {
  final BookingRepository _bookingRepository;
  BookingHistoryViewModel(this._bookingRepository);

  bool isLoading = false;
  String? errorMessage;
  List<BookingRecord> bookings = [];

  /// try/catch/finally is load-bearing here: if the local or remote
  /// call throws for any reason, `isLoading` must still flip back to
  /// false, or the UI spins forever with no way out.
  Future<void> load({String? userId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      bookings = await _bookingRepository.getHistory(userId: userId);
    } catch (e, st) {
      debugPrint('CinElite: failed to load booking history: $e\n$st');
      errorMessage = e.toString();
      bookings = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retrySync({String? userId}) async {
    try {
      await _bookingRepository.retryPendingSync();
    } catch (e) {
      debugPrint('CinElite: retrySync failed: $e');
    }
    await load(userId: userId);
  }
}
