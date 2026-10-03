import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/booking_record.dart';
import '../viewmodels/booking_history_view_model.dart';
import '../viewmodels/booking_session_view_model.dart';

/// Assumes a [BookingHistoryViewModel] is already provided above it
/// (see HomeScreen's Bookings tab / BookingConfirmationScreen navigation).
class BookingHistoryScreen extends StatelessWidget {
  final bool embedded;
  const BookingHistoryScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingHistoryViewModel>();
    final session = context.read<BookingSessionViewModel>();
    final currency = NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');

    Widget list;
    if (vm.isLoading) {
      list = const Center(child: CircularProgressIndicator());
    } else if (vm.errorMessage != null) {
      list = Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 32),
              const SizedBox(height: 10),
              const Text("Couldn't load your bookings",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () => vm.load(userId: session.currentUser?.uid),
                child: const Text('TRY AGAIN'),
              ),
            ],
          ),
        ),
      );
    } else if (vm.bookings.isEmpty) {
      list = const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No bookings yet.\nBook a movie and it will show up here — '
            'saved locally on this device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    } else {
      list = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vm.bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final b = vm.bookings[i];
          return _BookingCard(booking: b, currency: currency);
        },
      );
    }

    if (embedded) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('MY BOOKINGS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textDark,
                        letterSpacing: 0.5)),
                IconButton(
                  tooltip: 'Retry cloud sync',
                  icon: const Icon(Icons.cloud_sync_outlined, size: 20),
                  onPressed: () => vm.retrySync(userId: session.currentUser?.uid),
                ),
              ],
            ),
          ),
          Expanded(child: list),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            tooltip: 'Retry cloud sync',
            icon: const Icon(Icons.cloud_sync_outlined),
            onPressed: () => vm.retrySync(userId: session.currentUser?.uid),
          ),
        ],
      ),
      body: list,
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingRecord booking;
  final NumberFormat currency;
  const _BookingCard({required this.booking, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(booking.movieTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                _SyncBadge(synced: booking.syncedToCloud),
              ],
            ),
            const SizedBox(height: 4),
            Text('${booking.cinemaName}  •  ${booking.showDate}  •  ${booking.showTime}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            Text('Seat(s): ${booking.seatIds.join(', ')}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ref: ${booking.referenceNo}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text(currency.format(booking.total),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  final bool synced;
  const _SyncBadge({required this.synced});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: synced ? const Color(0xFFE3F6E9) : const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            synced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            size: 12,
            color: synced ? AppColors.selected : const Color(0xFF8A6D00),
          ),
          const SizedBox(width: 4),
          Text(
            synced ? 'Synced' : 'Local only',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: synced ? AppColors.selected : const Color(0xFF8A6D00),
            ),
          ),
        ],
      ),
    );
  }
}
