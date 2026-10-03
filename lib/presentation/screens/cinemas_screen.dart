import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/cinema.dart';
import '../viewmodels/booking_session_view_model.dart';
import '../viewmodels/cinemas_view_model.dart';

/// Assumes a [CinemasViewModel] is already provided above it (see
/// HomeScreen, which scopes one for the embedded Cinemas tab).
class CinemasScreen extends StatelessWidget {
  final bool embedded;
  const CinemasScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CinemasViewModel>();
    final session = context.watch<BookingSessionViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final body = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!embedded)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              onChanged: (v) => context.read<CinemasViewModel>().setQuery(v),
              decoration: const InputDecoration(
                hintText: 'Search location',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ...vm.visibleCinemas.map((cinema) => _CinemaCard(
              cinema: cinema,
              isPreferred: session.preferredCinema?.id == cinema.id,
              onSelect: () {
                context.read<BookingSessionViewModel>().setPreferredCinema(cinema);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${cinema.name} set as preferred cinema')),
                );
              },
            )),
      ],
    );

    if (embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Cinemas')), body: body);
  }
}

class _CinemaCard extends StatelessWidget {
  final Cinema cinema;
  final bool isPreferred;
  final VoidCallback onSelect;

  const _CinemaCard({required this.cinema, required this.isPreferred, required this.onSelect});

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
                  Text(cinema.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(cinema.address,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
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
