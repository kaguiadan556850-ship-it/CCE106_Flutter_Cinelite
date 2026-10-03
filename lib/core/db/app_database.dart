import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Thin singleton wrapper around the local SQLite database.
/// Layer: core (infrastructure) — used only by data/datasources/local/*.
class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static const _dbName = 'cinelite.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookings (
            id TEXT PRIMARY KEY,
            movie_title TEXT NOT NULL,
            cinema_name TEXT NOT NULL,
            show_date TEXT NOT NULL,
            show_time TEXT NOT NULL,
            ticket_type_code TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            seat_ids TEXT NOT NULL,
            subtotal REAL NOT NULL,
            booking_fee REAL NOT NULL,
            total REAL NOT NULL,
            payment_method TEXT NOT NULL,
            reference_no TEXT NOT NULL,
            transaction_id TEXT NOT NULL,
            user_id TEXT,
            synced_to_cloud INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Test/debug helper — not used by the app at runtime.
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('bookings');
  }
}
