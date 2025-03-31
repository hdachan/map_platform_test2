import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/FavoriteService.dart';

class FavoriteStoresViewModel extends ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();
  List<Map<String, dynamic>> favoriteStores = [];
  Map<int, List<String>> storeImages = {};
  bool isLoading = false;

  Future<void> loadFavoriteStores() async {
    isLoading = true;
    notifyListeners();

    final stores = await _favoriteService.fetchFavoriteStores(); // 수정
    favoriteStores = stores;

    for (var store in stores) {
      final modirId = store['modir']['id'];
      final images = await _favoriteService.fetchImagesForModir(modirId);
      storeImages[modirId] = images;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> removeFavoriteStore(int storeId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await _favoriteService.removeFavorite(user.id, storeId);
      await loadFavoriteStores();
    }
  }

  Future<void> navigateToDestination(double latitude, double longitude, String destinationName) async {
    await _favoriteService.navigateToDestination(latitude, longitude, destinationName);
  }
}


class FavoriteButtonViewModel extends ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();
  bool isFavorite = false;

  Future<void> loadFavoriteStatus(String userId, int storeId) async {
    isFavorite = await _favoriteService.isFavoriteStore(userId, storeId);
    notifyListeners();
  }

  Future<void> toggleFavorite(String userId, int storeId) async {
    if (isFavorite) {
      await _favoriteService.removeFavorite(userId, storeId);
    } else {
      await _favoriteService.addFavorite(userId, storeId);
    }
    isFavorite = !isFavorite;
    notifyListeners();
  }
}