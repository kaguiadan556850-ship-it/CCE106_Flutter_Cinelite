import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/firebase/firebase_status.dart';
import '../../../domain/entities/booking_record.dart';

/// Confined to the data layer. Every method fails soft — callers
/// (BookingRepositoryImpl) decide what "best-effort" means, this class
/// just surfaces a bool/throws so the caller can catch it.
class FirestoreBookingDataSource {
  bool get isAvailable => isRealFirebaseConfigured();

  CollectionReference<Map<String, dynamic>>? get _collection {
    if (!isAvailable) return null;
    return FirebaseFirestore.instance.collection('bookings');
  }

  Future<void> upload(BookingRecord booking) async {
    final col = _collection;
    if (col == null) {
      throw StateError('Firestore is not configured.');
    }
    await col.doc(booking.id).set(booking.toFirestoreJson());
  }

  Future<List<BookingRecord>> fetchForUser(String userId) async {
    final col = _collection;
    if (col == null) return [];
    final snapshot = await col
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((d) => BookingRecord.fromFirestoreJson(d.id, d.data()))
        .toList();
  }
}
