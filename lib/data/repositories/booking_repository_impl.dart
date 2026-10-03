import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/booking_record.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/local/booking_local_data_source.dart';
import '../datasources/remote/firestore_booking_data_source.dart';

/// Local-first: every booking is written to sqflite immediately (this
/// is the operation the UI waits on, so confirmation never depends on
/// network). Syncing to Firestore is then attempted in the background
/// and never blocks or throws back to the caller — if it fails (no
/// network, Firebase not configured, etc.) the row just stays flagged
/// `synced_to_cloud = 0` and [retryPendingSync] will pick it up later.
class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource _local;
  final FirestoreBookingDataSource _remote;

  BookingRepositoryImpl(this._local, this._remote);

  @override
  Future<void> saveBooking(BookingRecord booking) async {
    await _local.insert(booking);
    unawaited(_trySync(booking));
  }

  Future<void> _trySync(BookingRecord booking) async {
    try {
      await _remote.upload(booking);
      await _local.markSynced(booking.id);
    } catch (e) {
      debugPrint('CinElite: Firestore sync deferred for ${booking.id}: $e');
      // Left unsynced on purpose; retryPendingSync() will pick it up.
    }
  }

  @override
  Future<List<BookingRecord>> getHistory({String? userId}) {
    return _local.getAll(userId: userId);
  }

  @override
  Future<void> retryPendingSync() async {
    final pending = await _local.getUnsynced();
    for (final booking in pending) {
      await _trySync(booking);
    }
  }
}
