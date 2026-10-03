import '../../../core/db/app_database.dart';
import '../../../domain/entities/booking_record.dart';
import 'booking_local_data_source.dart';

/// Real SQLite storage, confined to the data layer. Used on
/// Android/iOS/desktop — NOT usable on Flutter Web (see
/// booking_local_data_source.dart for why).
class SqfliteBookingLocalDataSource implements BookingLocalDataSource {
  @override
  Future<void> insert(BookingRecord booking) async {
    final db = await AppDatabase.instance.database;
    await db.insert('bookings', booking.toSqliteMap());
  }

  @override
  Future<void> markSynced(String id) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'bookings',
      {'synced_to_cloud': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<BookingRecord>> getAll({String? userId}) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'bookings',
      where: userId != null ? 'user_id = ?' : null,
      whereArgs: userId != null ? [userId] : null,
      orderBy: 'created_at DESC',
    );
    return rows.map(BookingRecord.fromSqliteMap).toList();
  }

  @override
  Future<List<BookingRecord>> getUnsynced() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'bookings',
      where: 'synced_to_cloud = 0',
      orderBy: 'created_at DESC',
    );
    return rows.map(BookingRecord.fromSqliteMap).toList();
  }
}
