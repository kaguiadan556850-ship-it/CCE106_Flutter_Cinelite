import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/slide_page_route.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/mock/mock_catalog_data_source.dart';
import '../../domain/entities/ticket.dart';
import '../viewmodels/booking_session_view_model.dart';
import '../widgets/common.dart';
import '../widgets/step_progress_indicator.dart';
import 'seat_selection_screen.dart';

class TicketSummaryScreen extends StatefulWidget {
  const TicketSummaryScreen({super.key});

  @override
  State<TicketSummaryScreen> createState() => _TicketSummaryScreenState();
}

class _TicketSummaryScreenState extends State<TicketSummaryScreen> {
  @override
  void initState() {
    super.initState();
    final session = context.read<BookingSessionViewModel>();
    if (session.ticketType == null) {
      session.setTicketType(MockData.ticketTypes.first);
    }
  }

  List<Seat> _buildSeatGrid() {
    const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    const seatsPerRow = 10;
    final seats = <Seat>[];
    const unavailable = {'A3', 'B7', 'C1', 'D5', 'D6', 'F9', 'G2'};
    for (final row in rows) {
      for (int n = 1; n <= seatsPerRow; n++) {
        final id = '$row$n';
        seats.add(Seat(
          id: id,
          row: row,
          number: n,
          status: unavailable.contains(id) ? SeatStatus.unavailable : SeatStatus.available,
        ));
      }
    }
    return seats;
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<BookingSessionViewModel>();
    final movie = session.selectedMovie!;
    final currency = NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Summary')),
      body: Column(
        children: [
          const StepProgressIndicator(step: 3, label: 'Ticket Summary'),
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
                ),
                const SizedBox(height: 18),
                const Text('SELECT TICKET TYPE',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5)),
                const SizedBox(height: 10),
                ...MockData.ticketTypes.map((t) => _TicketTypeCard(
                      type: t,
                      selected: session.ticketType?.code == t.code,
                      currency: currency,
                      onTap: () => context.read<BookingSessionViewModel>().setTicketType(t),
                    )),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove,
                              onTap: () => context.read<BookingSessionViewModel>().decrementQuantity(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('${session.ticketQuantity}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            _QtyButton(
                              icon: Icons.add,
                              onTap: () => context.read<BookingSessionViewModel>().incrementQuantity(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        PriceRow(label: 'Subtotal', value: currency.format(session.subtotal)),
                        const SizedBox(height: 8),
                        PriceRow(label: 'Booking Fee', value: currency.format(session.totalBookingFee)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1),
                        ),
                        PriceRow(label: 'TOTAL', value: currency.format(session.total), bold: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomActions(
            leftLabel: 'BACK',
            rightLabel: 'SELECT SEATS',
            onLeft: () => Navigator.of(context).pop(),
            onRight: () {
              final s = context.read<BookingSessionViewModel>();
              s.seats
                ..clear()
                ..addAll(_buildSeatGrid());
              Navigator.of(context).push(SlidePageRoute(page: const SeatSelectionScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class _TicketTypeCard extends StatelessWidget {
  final TicketType type;
  final bool selected;
  final NumberFormat currency;
  final VoidCallback onTap;

  const _TicketTypeCard({
    required this.type,
    required this.selected,
    required this.currency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${type.code}, ${type.label}, ${currency.format(type.price)}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.navy : Colors.grey.shade300,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.navy : AppColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(type.label,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Text(currency.format(type.price), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: icon == Icons.add ? 'Increase quantity' : 'Decrease quantity',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.navy)),
          child: Icon(icon, size: 18, color: AppColors.navy),
        ),
      ),
    );
  }
}
