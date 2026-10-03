import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../state/booking_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/payment_method_sheet.dart';
import '../widgets/step_progress_indicator.dart';
import 'booking_confirmation_screen.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final movie = booking.selectedMovie!;
    final currency = NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Column(
        children: [
          const StepProgressIndicator(step: 5, label: 'Payment'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BookingHeaderCard(
                  movie: movie,
                  location: booking.selectedCinema?.name ?? '-',
                  date: booking.selectedDate != null
                      ? DateFormat('MMM d, yyyy').format(booking.selectedDate!)
                      : '-',
                  time: booking.selectedTime ?? '-',
                  total: currency.format(booking.total),
                  extra: booking.selectedSeatLabel,
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.ticketType?.code ?? '',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${booking.ticketQuantity}x ${booking.ticketType?.label ?? ''}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text('PAYMENT',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        PriceRow(
                            label: 'Subtotal',
                            value: currency.format(booking.subtotal)),
                        const SizedBox(height: 8),
                        PriceRow(
                            label: 'Booking Fee',
                            value: currency.format(booking.totalBookingFee)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1),
                        ),
                        PriceRow(
                          label: 'TOTAL',
                          value: currency.format(booking.total),
                          bold: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final method =
                                  await showPaymentMethodSheet(context);
                              if (method != null && context.mounted) {
                                context
                                    .read<BookingProvider>()
                                    .setPaymentMethod(method);
                                context.read<BookingProvider>().confirmPayment();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const BookingConfirmationScreen(),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.credit_card),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('CARD PAYMENT'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
