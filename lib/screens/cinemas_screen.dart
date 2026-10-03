import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/cinema.dart';
import '../state/booking_provider.dart';
import '../theme/app_theme.dart';

/// Cinemas tab (Fig. 11): search bar + cinema cards.
/// [embedded] = true when shown inside HomeScreen's body (no extra AppBar).
class CinemasScreen extends StatefulWidget {
  final bool embedded;
  const CinemasScreen({super.key, this.embedded = false});

  @override
  State<CinemasScreen> createState() => _CinemasScreenState();
}

class _CinemasScreenState extends State<CinemasScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final cinemas = MockData.cinemas
        .where((c) =>
            c.name.toLowerCase().contains(_query.toLowerCase()) ||
            c.address.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    final body = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!widget.embedded)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search location',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ...cinemas.map((cinema) => _CinemaCard(
              cinema: cinema,
              isPreferred: booking.preferredCinema?.id == cinema.id,
              onSelect: () {
                context.read<BookingProvider>().setPreferredCinema(cinema);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${cinema.name} set as preferred cinema')),
                );
              },
            )),
      ],
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Cinemas')),
      body: body,
    );
  }
}

class _CinemaCard extends StatelessWidget {
  final Cinema cinema;
  final bool isPreferred;
  final VoidCallback onSelect;

  const _CinemaCard({
    required this.cinema,
    required this.isPreferred,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.pillUnselected,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.theaters, color: AppColors.navy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cinema.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(cinema.address,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            if (isPreferred)
              const Icon(Icons.check_circle, color: AppColors.selected)
            else
              OutlinedButton(
                onPressed: onSelect,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('SELECT', style: TextStyle(fontSize: 11)),
              ),
          ],
        ),
      ),
    );
  }
}
