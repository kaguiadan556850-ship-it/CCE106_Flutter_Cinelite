import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../state/booking_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/qr_placeholder.dart';
import 'home_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final movie = booking.selectedMovie!;
    final currency = NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');
    final txDate = booking.transactionDate ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 56,
                      height: 80,
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: movie.posterGradient)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(booking.selectedCinema?.name ?? '-',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textMuted)),
                        Text(
                          '${booking.selectedDate != null ? DateFormat('MMM d, yyyy').format(booking.selectedDate!) : '-'}  •  ${booking.selectedTime ?? '-'}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'CinElite',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.selected, size: 18),
                      SizedBox(width: 6),
                      const Text(
                        'BOOKING CONFIRMED',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.selected,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  QrPlaceholder(data: booking.referenceNo ?? 'CINELITE'),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'TRANSACTION SUMMARY',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow('Reference No.', booking.referenceNo ?? '-'),
                  _SummaryRow('Transaction ID', booking.transactionId ?? '-'),
                  _SummaryRow('Payment Type', booking.paymentMethodLabel),
                  _SummaryRow(
                      'Transaction Date',
                      DateFormat('MMM d, yyyy  h:mm a').format(txDate)),
                  _SummaryRow(
                      'Transaction Amount', currency.format(booking.total)),
                  const Divider(height: 24),
                  _SummaryRow('Location', booking.selectedCinema?.name ?? '-'),
                  _SummaryRow(
                      'Date',
                      booking.selectedDate != null
                          ? DateFormat('MMM d, yyyy').format(booking.selectedDate!)
                          : '-'),
                  _SummaryRow('Time', booking.selectedTime ?? '-'),
                  _SummaryRow('Seat(s)', booking.selectedSeatLabel),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Receipt saved (prototype - no file generated)')),
                        );
                      },
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('SAVE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('DONE'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
