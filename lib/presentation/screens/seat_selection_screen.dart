import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/slide_page_route.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/ticket.dart';
import '../viewmodels/booking_session_view_model.dart';
import '../widgets/common.dart';
import '../widgets/step_progress_indicator.dart';
import 'payment_summary_screen.dart';

class SeatSelectionScreen extends StatelessWidget {
  const SeatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<BookingSessionViewModel>();
    final movie = session.selectedMovie!;
    final currency = NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');
    final canContinue = session.selectedSeats.length == session.ticketQuantity;

    final rows = <String, List<Seat>>{};
    for (final s in session.seats) {
      rows.putIfAbsent(s.row, () => []).add(s);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Seats')),
      body: Column(
        children: [
          const StepProgressIndicator(step: 4, label: 'Seat Selection'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BookingHeaderCard(
                  movie: movie,
                  location: session.selectedCinema?.name ?? '-',
                  date: session.selectedDate != null
                      ? DateFormat('MMM d, yyyy').format(session.selectedDate!)
                      : '-',
                  time: session.selectedTime ?? '-',
                  total: currency.format(session.total),
                  extra: session.selectedSeatLabel,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('CHOOSE YOUR SEATS',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    Text(
                      '${session.selectedSeats.length}/${session.ticketQuantity} selected',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const _SeatLegend(),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SCREEN THIS WAY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: AppColors.textMuted),
                        ),
                      ),
                      ...rows.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                child: Text(entry.key,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textMuted)),
                              ),
                              const SizedBox(width: 4),
                              ...entry.value.map((seat) => _SeatButton(seat: seat)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomActions(
            leftLabel: 'BACK',
            rightLabel: 'CONTINUE',
            onLeft: () => Navigator.of(context).pop(),
            onRight: canContinue
                ? () => Navigator.of(context).push(SlidePageRoute(page: const PaymentSummaryScreen()))
                : null,
          ),
        ],
      ),
    );
  }
}

class _SeatLegend extends StatelessWidget {
  const _SeatLegend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        _LegendItem(color: AppColors.available, icon: null, label: 'Available'),
        _LegendItem(color: AppColors.selected, icon: Icons.check, label: 'Your selection'),
        _LegendItem(color: AppColors.unavailable, icon: Icons.close, label: 'Unavailable'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String label;
  const _LegendItem({required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          child: icon != null ? Icon(icon, size: 12, color: Colors.white) : null,
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }
}

/// Dual-coded (color + icon) so the map stays legible for users with
/// color vision deficiency — implements the "Color-Blind Safe Seat Map"
/// assistive feature from the project write-up.
class _SeatButton extends StatelessWidget {
  final Seat seat;
  const _SeatButton({required this.seat});

  @override
  Widget build(BuildContext context) {
    final session = context.read<BookingSessionViewModel>();
    Color color;
    IconData? icon;
    switch (seat.status) {
      case SeatStatus.available:
        color = AppColors.available;
        icon = null;
        break;
      case SeatStatus.selected:
        color = AppColors.selected;
        icon = Icons.check;
        break;
      case SeatStatus.unavailable:
        color = AppColors.unavailable;
        icon = Icons.close;
        break;
    }

    return Semantics(
      button: true,
      enabled: seat.status != SeatStatus.unavailable,
      selected: seat.status == SeatStatus.selected,
      label: seat.status == SeatStatus.unavailable
          ? 'Seat ${seat.id}, unavailable'
          : 'Seat ${seat.id}, ${seat.status == SeatStatus.selected ? 'selected' : 'available'}',
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: InkWell(
          onTap: () => session.toggleSeat(seat),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            child: icon != null ? Icon(icon, size: 14, color: Colors.white) : null,
          ),
        ),
      ),
    );
  }
}
