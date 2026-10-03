import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/movie.dart';
import '../state/booking_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_poster_card.dart';
import 'cinemas_screen.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0; // 0 = Movies, 1 = Cinemas
  bool _nowShowing = true;
  final _searchController = TextEditingController();
  String _query = '';

  void _openMovie(Movie movie) {
    context.read<BookingProvider>().startBooking(movie);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MovieDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text('CinElite'),
        actions: [
          IconButton(
            tooltip: 'Toggle high-contrast mode',
            icon: Icon(
              booking.highContrast
                  ? Icons.contrast
                  : Icons.contrast_outlined,
            ),
            onPressed: () => context.read<BookingProvider>().toggleHighContrast(),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.pillUnselected,
            child: Icon(Icons.person, size: 18, color: AppColors.navy),
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                _NavPill(
                  label: 'MOVIES',
                  selected: _navIndex == 0,
                  onTap: () => setState(() => _navIndex = 0),
                ),
                const SizedBox(width: 8),
                _NavPill(
                  label: 'CINEMAS',
                  selected: _navIndex == 1,
                  onTap: () => setState(() => _navIndex = 1),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, size: 18),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _navIndex == 1 ? const CinemasScreen(embedded: true) : _buildMoviesBody(),
    );
  }

  Widget _buildMoviesBody() {
    List<Movie> movies = _nowShowing ? MockData.nowShowing() : MockData.comingSoon();
    if (_query.isNotEmpty) {
      movies = movies
          .where((m) => m.title.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'BOOK FAST, WATCH BIG!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'YOUR MOVIE MOMENTS STARTS HERE\nLIGHTS, CAMERA, TOGETHER!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _TabToggle(
                  label: 'NOW SHOWING',
                  selected: _nowShowing,
                  onTap: () => setState(() => _nowShowing = true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TabToggle(
                  label: 'COMING SOON',
                  selected: !_nowShowing,
                  onTap: () => setState(() => _nowShowing = false),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (movies.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No movies found.')),
          )
        else
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 14,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, i) {
              final movie = movies[i];
              return MoviePosterCard(
                movie: movie,
                onTap: () => _openMovie(movie),
              );
            },
          ),
      ],
    );
  }
}

class _NavPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavPill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : AppColors.pillUnselected,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabToggle({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : Colors.white,
            border: Border.all(
              color: selected ? AppColors.navy : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
