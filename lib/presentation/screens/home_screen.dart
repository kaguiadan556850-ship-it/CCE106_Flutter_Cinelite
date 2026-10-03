import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/slide_page_route.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/cinema_repository.dart';
import '../viewmodels/booking_history_view_model.dart';
import '../viewmodels/booking_session_view_model.dart';
import '../viewmodels/cinemas_view_model.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/movie_poster_card.dart';
import 'cinemas_screen.dart';
import 'booking_history_screen.dart';
import 'movie_details_screen.dart';

/// Assumes a [HomeViewModel] is already provided above it in the tree
/// (see LoginScreen, which wraps this screen with one on navigation).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 = Home (movies), 1 = Cinemas, 2 = Bookings, 3 = More
  int _navIndex = 0;
  final _searchController = TextEditingController();

  late final CinemasViewModel _cinemasVm;
  late final BookingHistoryViewModel _bookingsVm;

  @override
  void initState() {
    super.initState();
    final session = context.read<BookingSessionViewModel>();
    _cinemasVm = CinemasViewModel(context.read<CinemaRepository>())..load();
    _bookingsVm = BookingHistoryViewModel(context.read<BookingRepository>())
      ..load(userId: session.currentUser?.uid);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cinemasVm.dispose();
    _bookingsVm.dispose();
    super.dispose();
  }

  void _openMovie(Movie movie) {
    final session = context.read<BookingSessionViewModel>();
    session.startBooking(movie);
    Navigator.of(context).push(SlidePageRoute(page: const MovieDetailsScreen()));
  }

  void _onSearchChanged(String v) {
    switch (_navIndex) {
      case 0:
        context.read<HomeViewModel>().setQuery(v);
        break;
      case 1:
        _cinemasVm.setQuery(v);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeViewModel>();
    final showSearch = _navIndex == 0 || _navIndex == 1;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text('CinElite'),
        actions: const [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.pillUnselected,
            child: Icon(Icons.person, size: 18, color: AppColors.navy),
          ),
          SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(showSearch ? 60 : 0),
          child: showSearch
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: _navIndex == 0 ? 'Search movies' : 'Search location',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: IndexedStack(
        index: _navIndex,
        children: [
          _buildMoviesBody(home),
          ChangeNotifierProvider.value(
            value: _cinemasVm,
            child: const CinemasScreen(embedded: true),
          ),
          ChangeNotifierProvider.value(
            value: _bookingsVm,
            child: const BookingHistoryScreen(embedded: true),
          ),
          const _MoreTab(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          _searchController.clear();
          if (i == 2) {
            final session = context.read<BookingSessionViewModel>();
            _bookingsVm.load(userId: session.currentUser?.uid);
          }
        },
        items: const [
          BottomNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
          BottomNavItem(
              icon: Icons.theaters_outlined, selectedIcon: Icons.theaters, label: 'Cinemas'),
          BottomNavItem(
              icon: Icons.confirmation_number_outlined,
              selectedIcon: Icons.confirmation_number,
              label: 'Bookings'),
          BottomNavItem(icon: Icons.more_horiz, selectedIcon: Icons.more_horiz, label: 'More'),
        ],
      ),
    );
  }

  Widget _buildMoviesBody(HomeViewModel home) {
    if (home.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final movies = home.visibleMovies;

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
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
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
                  selected: home.nowShowingTabSelected,
                  onTap: () => context.read<HomeViewModel>().selectTab(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TabToggle(
                  label: 'COMING SOON',
                  selected: !home.nowShowingTabSelected,
                  onTap: () => context.read<HomeViewModel>().selectTab(false),
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
              return MoviePosterCard(movie: movie, onTap: () => _openMovie(movie));
            },
          ),
      ],
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
            border: Border.all(color: selected ? AppColors.navy : Colors.grey.shade300),
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

class _MoreTab extends StatelessWidget {
  const _MoreTab();

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthRepository>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: Icon(
              authRepo.isCloudConnected ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
              color: authRepo.isCloudConnected ? AppColors.selected : AppColors.textMuted,
            ),
            title: const Text('Cloud sync', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              authRepo.isCloudConnected
                  ? 'Connected — bookings sync to your account.'
                  : 'Offline mode — bookings are saved on this device only.',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.navy),
            title: Text('CinElite', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('Cinema booking prototype · v1.0', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
