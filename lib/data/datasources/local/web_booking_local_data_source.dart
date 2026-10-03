import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/booking_record.dart';
import 'booking_local_data_source.dart';

/// Flutter Web has no sqflite backend, so this stores bookings as a
/// JSON-encoded list under a single shared_preferences key instead.
/// Same public contract as [SqfliteBookingLocalDataSource] — the rest
/// of the app can't tell which one it's talking to.
class WebBookingLocalDataSource implements BookingLocalDataSource {
  static const _key = 'cinelite_bookings_v1';

  Future<List<Map<String, dynamic>>> _readRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> _writeRaw(List<Map<String, dynamic>> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(rows));
  }

  @override
  Future<void> insert(BookingRecord booking) async {
    final rows = await _readRaw();
    rows.insert(0, _toJsonRow(booking));
    await _writeRaw(rows);
  }

  @override
  Future<void> markSynced(String id) async {
    final rows = await _readRaw();
    final i = rows.indexWhere((r) => r['id'] == id);
    if (i != -1) {
      rows[i] = {...rows[i], 'synced_to_cloud': 1};
      await _writeRaw(rows);
    }
  }

  @override
  Future<List<BookingRecord>> getAll({String? userId}) async {
    final rows = await _readRaw();
    final filtered = userId == null ? rows : rows.where((r) => r['user_id'] == userId);
    final records = filtered.map(_fromJsonRow).toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  @override
  Future<List<BookingRecord>> getUnsynced() async {
    final rows = await _readRaw();
    final records =
        rows.where((r) => r['synced_to_cloud'] == 0).map(_fromJsonRow).toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  // BookingRecord already has sqflite map <-> record converters that
  // use plain JSON-safe types (String/int/double), so they double as
  // our JSON row format here too.
  Map<String, dynamic> _toJsonRow(BookingRecord booking) => booking.toSqliteMap();

  BookingRecord _fromJsonRow(Map<String, dynamic> row) =>
      BookingRecord.fromSqliteMap(row);
}
