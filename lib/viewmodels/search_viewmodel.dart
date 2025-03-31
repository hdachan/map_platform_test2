// lib/viewmodels/search_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/search_service.dart';
import 'map_viewmodel.dart';


class SearchViewModel with ChangeNotifier {
  final SearchService _searchService = SearchService();
  Timer? _debounce;
  bool _isLoading = false;
  List<Map<String, dynamic>> _searchResults = [];
  static const int _minSearchLength = 2;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get searchResults => _searchResults;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (query.length >= _minSearchLength) {
        fetchSearchResults(query);
      } else {
        _searchResults = [];
        notifyListeners();
      }
    });
  }

  Future<void> fetchSearchResults(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _searchService.fetchSearchResults(query);
    } catch (e) {
      _searchResults = [{'title': 'Error: $e', 'latitude': '0.0', 'longitude': '0.0'}];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void moveToLocation(BuildContext context, double lat, double lng) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    mapProvider.moveToLocation(lat, lng);
  }

  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}