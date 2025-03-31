import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> isFavoriteStore(String userId, int storeId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('store_id', storeId);

      return response.isNotEmpty;
    } catch (e) {
      log('❌ 관심 등록 여부 확인 실패: $e');
      return false;
    }
  }

  Future<bool> addFavorite(String userId, int storeId) async {
    try {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'store_id': storeId,
        'created_at': DateTime.now().toIso8601String(),
      });
      log('✅ 관심 매장 등록 성공: storeId = $storeId');
      return true;
    } catch (e) {
      log('❌ 관심 매장 등록 실패: $e');
      return false;
    }
  }

  Future<void> removeFavorite(String userId, int storeId) async {
    try {
      log('🗑 삭제 요청: user_id = $userId, store_id = $storeId');
      final response = await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('store_id', storeId);
      log('🔍 DELETE Response: $response');
      if (response == null || response.isEmpty) {
        log('❌ 삭제 실패: 응답이 없음');
      } else {
        log('✅ 관심 매장 삭제 성공: storeId = $storeId');
      }
    } catch (e) {
      log('❌ 관심 매장 삭제 중 오류 발생: $e');
    }
  }

  // private에서 public으로 변경
  Future<List<Map<String, dynamic>>> fetchFavoriteStores() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      log("로그인이 필요합니다.");
      return [];
    }

    final response = await _supabase
        .from('favorites')
        .select('store_id, modir(id, title, address, roadAddress, mapx, mapy)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<String>> fetchImagesForModir(int modirId) async {
    try {
      final response = await _supabase
          .from('modir_images')
          .select('image_url')
          .eq('modir_id', modirId);
      return response.isNotEmpty
          ? response.map((row) => row['image_url'] as String).toList()
          : [];
    } catch (e) {
      log('Error fetching images for modir $modirId: $e');
      return [];
    }
  }

  Future<void> navigateToDestination(double latitude, double longitude, String destinationName, {String? address}) async {
    try {
      double endLat = double.parse(latitude.toStringAsFixed(7));
      double endLng = double.parse(longitude.toStringAsFixed(7));
      final appUrl = Uri.parse(
        "nmap://place?lat=$endLat&lng=$endLng&name=${Uri.encodeComponent(destinationName)}&appname=com.example.untitled114",
      );
      final webUrl = Uri.parse(
        "https://map.naver.com/v5/search/$destinationName?lat=$endLat&lng=$endLng",
      );
      bool canLaunchApp = await canLaunchUrl(appUrl);
      if (canLaunchApp) {
        await launchUrl(appUrl);
      } else {
        bool canLaunchWeb = await canLaunchUrl(webUrl);
        if (canLaunchWeb) {
          await launchUrl(webUrl);
        }
      }
    } catch (e) {
      log('Error navigating to destination: $e');
    }
  }
}