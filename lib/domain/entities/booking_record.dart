/// A completed booking, as persisted to both the local sqflite database
/// and (best-effort) to Cloud Firestore. This is the entity the
/// repository layer works with — screens/viewmodels never touch raw
/// SQL or Firestore documents directly.
class BookingRecord {
  final String id; // local primary key = transactionId
  final String movieTitle;
  final String cinemaName;
  final String showDate; // ISO 8601 date string
  final String showTime;
  final String ticketTypeCode;
  final int quantity;
  final List<String> seatIds;
  final double subtotal;
  final double bookingFee;
  final double total;
  final String paymentMethod;
  final String referenceNo;
  final String transactionId;
  final String? userId;
  final bool syncedToCloud;
  final DateTime createdAt;

  const BookingRecord({
    required this.id,
    required this.movieTitle,
    required this.cinemaName,
    required this.showDate,
    required this.showTime,
    required this.ticketTypeCode,
    required this.quantity,
    required this.seatIds,
    required this.subtotal,
    required this.bookingFee,
    required this.total,
    required this.paymentMethod,
    required this.referenceNo,
    required this.transactionId,
    required this.createdAt,
    this.userId,
    this.syncedToCloud = false,
  });

  BookingRecord copyWith({bool? syncedToCloud}) => BookingRecord(
        id: id,
        movieTitle: movieTitle,
        cinemaName: cinemaName,
        showDate: showDate,
        showTime: showTime,
        ticketTypeCode: ticketTypeCode,
        quantity: quantity,
        seatIds: seatIds,
        subtotal: subtotal,
        bookingFee: bookingFee,
        total: total,
        paymentMethod: paymentMethod,
        referenceNo: referenceNo,
        transactionId: transactionId,
        createdAt: createdAt,
        userId: userId,
        syncedToCloud: syncedToCloud ?? this.syncedToCloud,
      );

  // ---- sqflite (local) ----

  Map<String, Object?> toSqliteMap() => {
        'id': id,
        'movie_title': movieTitle,
        'cinema_name': cinemaName,
        'show_date': showDate,
        'show_time': showTime,
        'ticket_type_code': ticketTypeCode,
        'quantity': quantity,
        'seat_ids': seatIds.join(','),
        'subtotal': subtotal,
        'booking_fee': bookingFee,
        'total': total,
        'payment_method': paymentMethod,
        'reference_no': referenceNo,
        'transaction_id': transactionId,
        'user_id': userId,
        'synced_to_cloud': syncedToCloud ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory BookingRecord.fromSqliteMap(Map<String, Object?> map) => BookingRecord(
        id: map['id'] as String,
        movieTitle: map['movie_title'] as String,
        cinemaName: map['cinema_name'] as String,
        showDate: map['show_date'] as String,
        showTime: map['show_time'] as String,
        ticketTypeCode: map['ticket_type_code'] as String,
        quantity: map['quantity'] as int,
        seatIds: ((map['seat_ids'] as String?) ?? '')
            .split(',')
            .where((s) => s.isNotEmpty)
            .toList(),
        subtotal: (map['subtotal'] as num).toDouble(),
        bookingFee: (map['booking_fee'] as num).toDouble(),
        total: (map['total'] as num).toDouble(),
        paymentMethod: map['payment_method'] as String,
        referenceNo: map['reference_no'] as String,
        transactionId: map['transaction_id'] as String,
        userId: map['user_id'] as String?,
        syncedToCloud: (map['synced_to_cloud'] as int) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  // ---- Firestore (remote) ----

  Map<String, dynamic> toFirestoreJson() => {
        'movieTitle': movieTitle,
        'cinemaName': cinemaName,
        'showDate': showDate,
        'showTime': showTime,
        'ticketTypeCode': ticketTypeCode,
        'quantity': quantity,
        'seatIds': seatIds,
        'subtotal': subtotal,
        'bookingFee': bookingFee,
        'total': total,
        'paymentMethod': paymentMethod,
        'referenceNo': referenceNo,
        'transactionId': transactionId,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BookingRecord.fromFirestoreJson(String docId, Map<String, dynamic> json) =>
      BookingRecord(
        id: docId,
        movieTitle: json['movieTitle'] as String,
        cinemaName: json['cinemaName'] as String,
        showDate: json['showDate'] as String,
        showTime: json['showTime'] as String,
        ticketTypeCode: json['ticketTypeCode'] as String,
        quantity: json['quantity'] as int,
        seatIds: List<String>.from(json['seatIds'] as List? ?? []),
        subtotal: (json['subtotal'] as num).toDouble(),
        bookingFee: (json['bookingFee'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        paymentMethod: json['paymentMethod'] as String,
        referenceNo: json['referenceNo'] as String,
        transactionId: json['transactionId'] as String,
        userId: json['userId'] as String?,
        syncedToCloud: true,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
