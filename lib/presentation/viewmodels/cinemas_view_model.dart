import 'package:flutter/material.dart';
import '../../domain/entities/cinema.dart';
import '../../domain/repositories/cinema_repository.dart';

class CinemasViewModel extends ChangeNotifier {
  final CinemaRepository _cinemaRepository;
  CinemasViewModel(this._cinemaRepository);

  bool isLoading = false;
  String query = '';
  List<Cinema> _all = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    _all = await _cinemaRepository.getCinemas();
    isLoading = false;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  List<Cinema> get visibleCinemas {
    if (query.isEmpty) return _all;
    final q = query.toLowerCase();
    return _all
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.address.toLowerCase().contains(q))
        .toList();
  }
}
