import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/local/booking_local_data_source.dart';
import 'data/datasources/local/sqflite_booking_local_data_source.dart';
import 'data/datasources/local/web_booking_local_data_source.dart';
import 'data/datasources/remote/firebase_auth_data_source.dart';
import 'data/datasources/remote/firestore_booking_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/booking_repository_impl.dart';
import 'data/repositories/cinema_repository_impl.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/booking_repository.dart';
import 'domain/repositories/cinema_repository.dart';
import 'domain/repositories/movie_repository.dart';
import 'firebase_options.dart';
import 'presentation/viewmodels/booking_session_view_model.dart';
import 'presentation/screens/login_screen.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase is optional at runtime: with no real project wired up in
  // firebase_options.dart, this throws and we fall back to local-only
  // "offline mode" (see AuthRepositoryImpl / BookingRepositoryImpl).
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('CinElite: Firebase not configured, running in offline mode. ($e)');
  }

  // ---- Manual dependency injection (data sources -> repositories) ----
  final authDataSource = FirebaseAuthDataSource();

  // sqflite has no web backend and hangs forever instead of throwing
  // there, so Flutter Web gets a shared_preferences-backed local store
  // with the same interface instead. See booking_local_data_source.dart.
  final BookingLocalDataSource bookingLocalDataSource =
      kIsWeb ? WebBookingLocalDataSource() : SqfliteBookingLocalDataSource();

  final bookingRemoteDataSource = FirestoreBookingDataSource();

  final AuthRepository authRepository = AuthRepositoryImpl(authDataSource);
  final MovieRepository movieRepository = MovieRepositoryImpl();
  final CinemaRepository cinemaRepository = CinemaRepositoryImpl();
  final BookingRepository bookingRepository =
      BookingRepositoryImpl(bookingLocalDataSource, bookingRemoteDataSource);

  runApp(CinEliteApp(
    authRepository: authRepository,
    movieRepository: movieRepository,
    cinemaRepository: cinemaRepository,
    bookingRepository: bookingRepository,
  ));
}

class CinEliteApp extends StatelessWidget {
  final AuthRepository authRepository;
  final MovieRepository movieRepository;
  final CinemaRepository cinemaRepository;
  final BookingRepository bookingRepository;

  const CinEliteApp({
    super.key,
    required this.authRepository,
    required this.movieRepository,
    required this.cinemaRepository,
    required this.bookingRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories: plain singletons, available to every screen via
        // context.read<XRepository>() so each screen can build its own
        // scoped ViewModel.
        Provider<AuthRepository>.value(value: authRepository),
        Provider<MovieRepository>.value(value: movieRepository),
        Provider<CinemaRepository>.value(value: cinemaRepository),
        Provider<BookingRepository>.value(value: bookingRepository),

        // The one ViewModel that legitimately spans many screens: the
        // booking wizard itself.
        ChangeNotifierProvider(
          create: (ctx) => BookingSessionViewModel(bookingRepository, authRepository),
        ),
      ],
      child: Consumer<BookingSessionViewModel>(
        builder: (context, session, _) {
          return MaterialApp(
            title: 'CinElite',
            debugShowCheckedModeBanner: false,
            theme: session.highContrast ? AppTheme.highContrast : AppTheme.light,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
