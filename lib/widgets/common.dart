import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';

/// The recurring "movie + location/date/time + total" summary card shown
/// at the top of Ticket Summary, Seat Selection and Payment screens.
class BookingHeaderCard extends StatelessWidget {
  final Movie movie;
  final String location;
  final String date;
  final String time;
  final String total;
  final String? extra; // e.g. selected seat ids

  const BookingHeaderCard({
    super.key,
    required this.movie,
    required this.location,
    required this.date,
    required this.time,
    required this.total,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    gradient: LinearGradient(colors: movie.posterGradient)),
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
                  Text(location,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                  Text('$date  •  $time',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                  if (extra != null && extra!.isNotEmpty)
                    Text('Seat(s): $extra',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('TOTAL',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted)),
                Text(total,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.navy)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const PriceRow({super.key, required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 13,
      color: bold ? AppColors.navy : AppColors.textDark,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

/// Sticky Back / primary-action bar pinned to the bottom of booking screens.
class BottomActions extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final VoidCallback onLeft;
  final VoidCallback? onRight;

  const BottomActions({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: onLeft, child: Text(leftLabel)),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(onPressed: onRight, child: Text(rightLabel)),
            ),
          ],
        ),
      ),
    );
  }
}
