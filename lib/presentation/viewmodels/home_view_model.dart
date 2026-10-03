import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final MovieRepository _movieRepository;
  HomeViewModel(this._movieRepository);

  bool isLoading = false;
  bool nowShowingTabSelected = true;
  String query = '';
  List<Movie> _nowShowing = [];
  List<Movie> _comingSoon = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    final results = await Future.wait([
      _movieRepository.getNowShowing(),
      _movieRepository.getComingSoon(),
    ]);
    _nowShowing = results[0];
    _comingSoon = results[1];
    isLoading = false;
    notifyListeners();
  }

  void selectTab(bool nowShowing) {
    nowShowingTabSelected = nowShowing;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  List<Movie> get visibleMovies {
    final source = nowShowingTabSelected ? _nowShowing : _comingSoon;
    if (query.isEmpty) return source;
    return source
        .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
