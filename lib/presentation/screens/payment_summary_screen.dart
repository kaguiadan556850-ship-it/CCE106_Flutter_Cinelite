import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/slide_page_route.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/booking_session_view_model.dart';
import '../widgets/common.dart';
import '../widgets/payment_method_sheet.dart';
import '../widgets/step_progress_indicator.dart';
import 'booking_confirmation_screen.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({super.key});

  Future<void> _pay(BuildContext context) async {
    final session = context.read<BookingSessionViewModel>();
    final method = await showPaymentMethodSheet(context);
    if (method == null || !context.mounted) return;

    session.setPaymentMethod(method);
    await session.confirmPayment();
    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      FadeScalePageRoute(page: const BookingConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<BookingSessionViewModel>();
    final movie = session.selectedMovie!;
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
                  location: session.selectedCinema?.name ?? '-',
                  date: session.selectedDate != null
                      ? DateFormat('MMM d, yyyy').format(session.selectedDate!)
                      : '-',
                  time: session.selectedTime ?? '-',
                  total: currency.format(session.total),
                  extra: session.selectedSeatLabel,
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.ticketType?.code ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${session.ticketQuantity}x ${session.ticketType?.label ?? ''}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text('PAYMENT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: session.isSaving ? null : () => _pay(context),
                            icon: session.isSaving
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.credit_card),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(session.isSaving ? 'PROCESSING...' : 'CARD PAYMENT'),
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
