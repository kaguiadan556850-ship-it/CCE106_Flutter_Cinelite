import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/booking_record.dart';
import '../../domain/entities/cinema.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/booking_repository.dart';

/// Shared ViewModel for the multi-step booking wizard (Movie -> Cinema ->
/// Showtime -> Ticket -> Seats -> Payment -> Confirmation). A single
/// ViewModel spanning several Views is the right call here because the
/// steps are one continuous flow over one mutable selection, not
/// independent screens — this is provided once, app-wide, in main.dart.
///
/// Per-screen concerns (Home, Cinemas list, Login, Booking history) each
/// get their *own* dedicated ViewModel instead — see the other files in
/// this folder.
class BookingSessionViewModel extends ChangeNotifier {
  final BookingRepository _bookingRepository;
  final AuthRepository _authRepository;

  BookingSessionViewModel(this._bookingRepository, this._authRepository);

  // ---- App-wide preferences ----
  bool highContrast = false;
  Cinema? preferredCinema;

  void toggleHighContrast() {
    highContrast = !highContrast;
    notifyListeners();
  }

  void setPreferredCinema(Cinema cinema) {
    preferredCinema = cinema;
    notifyListeners();
  }

  // ---- Current booking selections ----
  Movie? selectedMovie;
  Cinema? selectedCinema;
  DateTime? selectedDate;
  String? selectedTime;
  TicketType? ticketType;
  int ticketQuantity = 1;
  List<Seat> seats = [];
  PaymentMethod? paymentMethod;

  // Transaction info generated on successful "payment"
  String? referenceNo;
  String? transactionId;
  DateTime? transactionDate;
  bool isSaving = false;
  bool lastSyncedToCloud = false;

  void startBooking(Movie movie) {
    selectedMovie = movie;
    selectedCinema = preferredCinema;
    selectedDate = null;
    selectedTime = null;
    ticketType = null;
    ticketQuantity = 1;
    seats = [];
    paymentMethod = null;
    referenceNo = null;
    transactionId = null;
    transactionDate = null;
    notifyListeners();
  }

  void setCinema(Cinema cinema) {
    selectedCinema = cinema;
    preferredCinema = cinema;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  void setTicketType(TicketType type) {
    ticketType = type;
    notifyListeners();
  }

  void incrementQuantity() {
    if (ticketQuantity < 8) {
      ticketQuantity++;
      notifyListeners();
    }
  }

  void decrementQuantity() {
    if (ticketQuantity > 1) {
      ticketQuantity--;
      notifyListeners();
    }
  }

  double get subtotal => (ticketType?.price ?? 0) * ticketQuantity;
  double get totalBookingFee => 20.0 * ticketQuantity;
  double get total => subtotal + totalBookingFee;

  void toggleSeat(Seat seat) {
    if (seat.status == SeatStatus.unavailable) return;
    if (seat.status == SeatStatus.selected) {
      seat.status = SeatStatus.available;
    } else {
      final currentlySelected =
          seats.where((s) => s.status == SeatStatus.selected).length;
      if (currentlySelected >= ticketQuantity) return;
      seat.status = SeatStatus.selected;
    }
    notifyListeners();
  }

  List<Seat> get selectedSeats =>
      seats.where((s) => s.status == SeatStatus.selected).toList();

  String get selectedSeatLabel => selectedSeats.map((s) => s.id).join(', ');

  void setPaymentMethod(PaymentMethod method) {
    paymentMethod = method;
    notifyListeners();
  }

  AppUser? get currentUser => _authRepository.currentUser;

  /// Simulates a successful payment, generates a transaction record,
  /// and persists it (sqflite immediately, Firestore best-effort).
  Future<void> confirmPayment() async {
    isSaving = true;
    notifyListeners();

    final rand = Random();
    referenceNo = (100000000 + rand.nextInt(899999999)).toString();
    transactionId =
        'T${rand.nextInt(9000000) + 1000000}${String.fromCharCode(65 + rand.nextInt(26))}';
    transactionDate = DateTime.now();

    final record = BookingRecord(
      id: transactionId!,
      movieTitle: selectedMovie?.title ?? '',
      cinemaName: selectedCinema?.name ?? '',
      showDate: selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
          : '',
      showTime: selectedTime ?? '',
      ticketTypeCode: ticketType?.code ?? '',
      quantity: ticketQuantity,
      seatIds: selectedSeats.map((s) => s.id).toList(),
      subtotal: subtotal,
      bookingFee: totalBookingFee,
      total: total,
      paymentMethod: paymentMethodLabel,
      referenceNo: referenceNo!,
      transactionId: transactionId!,
      userId: currentUser?.uid,
      createdAt: transactionDate!,
    );

    await _bookingRepository.saveBooking(record);

    isSaving = false;
    notifyListeners();
  }

  String get paymentMethodLabel {
    switch (paymentMethod) {
      case PaymentMethod.card:
        return 'CREDIT CARD';
      case PaymentMethod.gcash:
        return 'GCASH';
      case PaymentMethod.grabpay:
        return 'GRABPAY';
      case null:
        return '--';
    }
  }
}
