import 'package:flutter/material.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/cinema.dart';
import '../../../domain/entities/ticket.dart';

class MockData {
  MockData._();

  static const List<Movie> movies = [
    Movie(
      id: 'avatar-foa',
      title: 'Avatar: Fire and Ash',
      genre: 'Action / Adventure',
      rating: 'Parental Guidance Recommended',
      runtime: '3h 17m',
      releaseDate: '17 December 2025',
      cast: 'Sam Worthington, Zoe Saldaña, Kate Winslet',
      synopsis:
          "Jake and Neytiri's family grapples with grief after Neteyam's "
          "death, encountering a new, aggressive Na'vi tribe, the Ash "
          "People, who are led by the fiery Varang, as the conflict on "
          "Pandora escalates and a new moral focus emerges.",
      posterGradient: [Color(0xFF0B3D91), Color(0xFF1B6CA8)],
    ),
    Movie(
      id: 'demon-slayer',
      title: 'Demon Slayer',
      genre: 'Animation / Fantasy',
      rating: 'PG-13',
      runtime: '2h 35m',
      releaseDate: '10 October 2025',
      cast: 'Natsuki Hanae, Akari Kito, Hiro Shimono',
      synopsis:
          'Tanjiro and the Demon Slayer Corps face their fiercest '
          'battle yet as they push deeper into demon territory.',
      posterGradient: [Color(0xFF6A0F49), Color(0xFFB23A6B)],
    ),
    Movie(
      id: 'whistle',
      title: 'Whistle',
      genre: 'Horror / Mystery',
      rating: 'R-13',
      runtime: '1h 48m',
      releaseDate: '5 November 2025',
      cast: 'Coco Martin, Julia Barretto',
      synopsis:
          'A cursed whistle resurfaces in a small town, and those who '
          'hear it begin to disappear one by one.',
      posterGradient: [Color(0xFF2B2B2B), Color(0xFF6A6A6A)],
    ),
    Movie(
      id: 'strangers',
      title: 'The Strangers',
      genre: 'Horror / Thriller',
      rating: 'R-16',
      runtime: '1h 31m',
      releaseDate: '20 September 2025',
      cast: 'Madelaine Petsch, Froy Gutierrez',
      synopsis:
          'A couple stranded in a remote cabin is terrorized overnight '
          'by three masked strangers with no apparent motive.',
      posterGradient: [Color(0xFF7A1C1C), Color(0xFF2B2B2B)],
    ),
    Movie(
      id: 'goat',
      title: 'Goat',
      genre: 'Drama',
      rating: 'PG',
      runtime: '1h 56m',
      releaseDate: '2026',
      cast: 'Ensemble Cast',
      synopsis: 'A heartfelt story of family, sacrifice, and redemption.',
      posterGradient: [Color(0xFF3D5A2F), Color(0xFF8CAE6B)],
      comingSoon: true,
    ),
    Movie(
      id: 'diablo',
      title: 'Diablo',
      genre: 'Action',
      rating: 'R-13',
      runtime: '2h 05m',
      releaseDate: '2026',
      cast: 'Scott Adkins',
      synopsis: 'A former cartel enforcer is pulled back for one last job.',
      posterGradient: [Color(0xFF8A1C1C), Color(0xFF1B1B1B)],
      comingSoon: true,
    ),
    Movie(
      id: 'shelter',
      title: 'A Shelter',
      genre: 'Drama / Thriller',
      rating: 'PG-13',
      runtime: '1h 47m',
      releaseDate: '2026',
      cast: 'Ensemble Cast',
      synopsis: 'Strangers trapped by a storm must learn to trust again.',
      posterGradient: [Color(0xFF264653), Color(0xFF2A9D8F)],
      comingSoon: true,
    ),
    Movie(
      id: 'send-help',
      title: 'Send Help',
      genre: 'Thriller',
      rating: 'R-16',
      runtime: '1h 39m',
      releaseDate: '2026',
      cast: 'Ensemble Cast',
      synopsis: 'Stranded survivors realize their rescue signal was a trap.',
      posterGradient: [Color(0xFFB2262E), Color(0xFF3A3A3A)],
      comingSoon: true,
    ),
  ];

  static List<Movie> nowShowing() =>
      movies.where((m) => !m.comingSoon).toList();

  static List<Movie> comingSoon() =>
      movies.where((m) => m.comingSoon).toList();

  static const List<Cinema> cinemas = [
    Cinema(
      id: 'sm-davao',
      name: 'SM City Davao',
      address: 'Quimpo Blvd, Ecoland, Davao City',
    ),
    Cinema(
      id: 'sm-lanang',
      name: 'SM Lanang Premier',
      address: 'JP Laurel Ave, Lanang, Davao City',
    ),
    Cinema(
      id: 'sm-mall-of-asia',
      name: 'SM Mall of Asia',
      address: 'Seaside Blvd, Pasay City',
    ),
    Cinema(
      id: 'sm-north-edsa',
      name: 'SM City North EDSA',
      address: 'North Ave, Quezon City',
    ),
    Cinema(
      id: 'sm-cebu',
      name: 'SM City Cebu',
      address: 'North Reclamation Area, Cebu City',
    ),
    Cinema(
      id: 'sm-megamall',
      name: 'SM Megamall',
      address: 'Doña Julia Vargas Ave, Ortigas, Mandaluyong',
    ),
  ];

  static const List<TicketType> ticketTypes = [
    TicketType(
      code: 'REG*',
      label: '1x REG**, 1x Free Bottle Drinking Water 500 ml',
      price: 320,
    ),
    TicketType(
      code: 'STUDENT*',
      label: '1x STUDENT**, valid ID required',
      price: 260,
    ),
    TicketType(
      code: 'SENIOR/PWD*',
      label: '1x SENIOR/PWD**, valid ID required',
      price: 260,
    ),
  ];

  static const double bookingFee = 20;

  /// A short strip of selectable dates, "TODAY" + the next few days.
  static List<DateTime> upcomingDates() {
    final now = DateTime.now();
    return List.generate(6, (i) => DateTime(now.year, now.month, now.day + i));
  }

  static const List<String> showtimeSlots = [
    '12:30 PM',
    '3:30 PM',
    '6:30 PM',
    '9:30 PM',
  ];
}
