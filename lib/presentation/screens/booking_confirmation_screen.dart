import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/slide_page_route.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/movie_repository.dart';
import '../viewmodels/booking_history_view_model.dart';
import '../viewmodels/booking_session_view_model.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/qr_placeholder.dart';
import 'booking_history_screen.dart';
import 'home_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<BookingSessionViewModel>();
    final movie = session.selectedMovie!;
    final currency = NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');
    final txDate = session.transactionDate ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmation'), automaticallyImplyLeading: false),
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
                      decoration: BoxDecoration(gradient: LinearGradient(colors: movie.posterGradient)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(session.selectedCinema?.name ?? '-',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        Text(
                          '${session.selectedDate != null ? DateFormat('MMM d, yyyy').format(session.selectedDate!) : '-'}  •  ${session.selectedTime ?? '-'}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
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
                      Icon(Icons.check_circle, color: AppColors.selected, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'BOOKING CONFIRMED',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.selected,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Saved to this device'
                    '${session.currentUser != null ? " and syncing to your account" : ""}.',
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 18),
                  QrPlaceholder(data: session.referenceNo ?? 'CINELITE'),
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
                  _SummaryRow('Reference No.', session.referenceNo ?? '-'),
                  _SummaryRow('Transaction ID', session.transactionId ?? '-'),
                  _SummaryRow('Payment Type', session.paymentMethodLabel),
                  _SummaryRow('Transaction Date', DateFormat('MMM d, yyyy  h:mm a').format(txDate)),
                  _SummaryRow('Transaction Amount', currency.format(session.total)),
                  const Divider(height: 24),
                  _SummaryRow('Location', session.selectedCinema?.name ?? '-'),
                  _SummaryRow(
                      'Date',
                      session.selectedDate != null
                          ? DateFormat('MMM d, yyyy').format(session.selectedDate!)
                          : '-'),
                  _SummaryRow('Time', session.selectedTime ?? '-'),
                  _SummaryRow('Seat(s)', session.selectedSeatLabel),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Receipt saved (prototype - no file generated)')),
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  SlidePageRoute(
                    page: ChangeNotifierProvider(
                      create: (ctx) => BookingHistoryViewModel(ctx.read<BookingRepository>())
                        ..load(userId: session.currentUser?.uid),
                      child: const BookingHistoryScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.confirmation_number_outlined),
              label: const Text('VIEW MY BOOKINGS'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  FadeScalePageRoute(
                    page: ChangeNotifierProvider(
                      create: (ctx) => HomeViewModel(ctx.read<MovieRepository>())..load(),
                      child: const HomeScreen(),
                    ),
                  ),
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
          Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
