import 'package:flutter/material.dart';

/// Simple genre-based gradient so the prototype doesn't depend on
/// network images for posters.
class Movie {
  final String id;
  final String title;
  final String genre;
  final String rating; // e.g. "PG-13", "Parental Guidance Recommended"
  final String runtime; // e.g. "3h 17m"
  final String releaseDate; // e.g. "17 December 2025"
  final String cast;
  final String synopsis;
  final bool comingSoon;
  final List<Color> posterGradient;

  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.runtime,
    required this.releaseDate,
    required this.cast,
    required this.synopsis,
    required this.posterGradient,
    this.comingSoon = false,
  });
}
