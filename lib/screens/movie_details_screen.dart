import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../state/booking_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cinema_selector_sheet.dart';
import 'ticket_summary_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final movie = booking.selectedMovie!;
    final dates = MockData.upcomingDates();

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // "Trailer" placeholder
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: movie.posterGradient),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 56),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 74,
                  height: 106,
                  decoration:
                      BoxDecoration(gradient: LinearGradient(colors: movie.posterGradient)),
                  child: const Icon(Icons.local_movies, color: Colors.white70),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Cast', value: movie.cast),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Synopsis', value: movie.synopsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoRow(label: 'Runtime', value: movie.runtime),
                  ),
                  Expanded(
                    child: _InfoRow(
                        label: 'Release date', value: movie.releaseDate),
                  ),
                  Expanded(
                    child: _InfoRow(label: movie.genre, value: movie.rating),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('SHOWTIMES',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 14),
          if (booking.selectedCinema == null)
            _NoCinemaSelected(onAdd: () async {
              final cinema = await showCinemaSelectorSheet(context);
              if (cinema != null && context.mounted) {
                context.read<BookingProvider>().setCinema(cinema);
              }
            })
          else ...[
            Text(booking.selectedCinema!.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.navy)),
            Text(booking.selectedCinema!.address,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 12),
            _DateStrip(
              dates: dates,
              selected: booking.selectedDate,
              onSelect: (d) => context.read<BookingProvider>().setDate(d),
            ),
            const SizedBox(height: 18),
            const Text('AVAILABLE SHOWTIMES',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: MockData.showtimeSlots.map((time) {
                final selected = booking.selectedTime == time;
                return _TimeChip(
                  label: time,
                  selected: selected,
                  onTap: () {
                    context.read<BookingProvider>().setTime(time);
                    if (booking.selectedDate == null) {
                      context.read<BookingProvider>().setDate(dates.first);
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const TicketSummaryScreen()),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final cinema = await showCinemaSelectorSheet(
                    context,
                    initiallySelected: booking.selectedCinema,
                  );
                  if (cinema != null && context.mounted) {
                    context.read<BookingProvider>().setCinema(cinema);
                  }
                },
                icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
                label: const Text('CHANGE CINEMA'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12.5, height: 1.3)),
      ],
    );
  }
}

class _NoCinemaSelected extends StatelessWidget {
  final VoidCallback onAdd;
  const _NoCinemaSelected({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(Icons.location_on, size: 40, color: AppColors.navy),
          const SizedBox(height: 10),
          const Text('No cinema selected',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Where would you like to see the movie?',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 14),
          ElevatedButton(onPressed: onAdd, child: const Text('ADD CINEMAS')),
        ],
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selected;
  final ValueChanged<DateTime> onSelect;

  const _DateStrip(
      {required this.dates, required this.selected, required this.onSelect});

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final d = dates[i];
          final isSelected =
              selected != null && DateUtils.isSameDay(selected, d);
          return Semantics(
            button: true,
            selected: isSelected,
            label: _isToday(d) ? 'Today' : DateFormat('EEE d MMM').format(d),
            child: InkWell(
              onTap: () => onSelect(d),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                constraints: const BoxConstraints(minWidth: 64),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.navy : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isSelected
                          ? AppColors.navy
                          : Colors.grey.shade300),
                ),
                child: Text(
                  _isToday(d) ? 'TODAY' : DateFormat('E\nd MMM').format(d),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TimeChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Showtime $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44, minWidth: 88),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: selected ? AppColors.navy : Colors.grey.shade300),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
