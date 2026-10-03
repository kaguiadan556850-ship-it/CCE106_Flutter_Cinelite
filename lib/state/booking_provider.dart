import 'dart:math';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/cinema.dart';
import '../models/movie.dart';
import '../models/ticket.dart';

/// Holds the state of the current booking flow (mirrors the multi-step
/// flow from the CinElite design: Movie -> Cinema -> Showtime -> Ticket
/// -> Seats -> Payment -> Confirmation) plus a couple of app-wide
/// preferences (preferred cinema, high-contrast mode).
class BookingProvider extends ChangeNotifier {
  // ---- App-wide preferences ----
  bool highContrast = false;
  Cinema? preferredCinema;

  void setPreferredCinema(Cinema cinema) {
    preferredCinema = cinema;
    notifyListeners();
  }

  void toggleHighContrast() {
    highContrast = !highContrast;
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
  double get totalBookingFee => MockData.bookingFee * ticketQuantity;
  double get total => subtotal + totalBookingFee;

  void toggleSeat(Seat seat) {
    if (seat.status == SeatStatus.unavailable) return;
    if (seat.status == SeatStatus.selected) {
      seat.status = SeatStatus.available;
    } else {
      final currentlySelected =
          seats.where((s) => s.status == SeatStatus.selected).length;
      if (currentlySelected >= ticketQuantity) return; // limit reached
      seat.status = SeatStatus.selected;
    }
    notifyListeners();
  }

  List<Seat> get selectedSeats =>
      seats.where((s) => s.status == SeatStatus.selected).toList();

  String get selectedSeatLabel =>
      selectedSeats.map((s) => s.id).join(', ');

  void setPaymentMethod(PaymentMethod method) {
    paymentMethod = method;
    notifyListeners();
  }

  /// Simulates a successful payment + generates a mock transaction record.
  void confirmPayment() {
    final rand = Random();
    referenceNo = (100000000 + rand.nextInt(899999999)).toString();
    transactionId =
        'T${rand.nextInt(9000000) + 1000000}${String.fromCharCode(65 + rand.nextInt(26))}';
    transactionDate = DateTime.now();
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
