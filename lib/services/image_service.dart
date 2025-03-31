import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class ImageService {
  final SupabaseClient supabase = Supabase.instance.client;
  // 이미지 캐시를 저장할 맵
  final Map<int, List<String>> _imageCache = {};

  // modir_id로 이미지 URL 리스트 가져오기
  Future<List<String>> fetchImagesByModirId(int modirId) async {
    // 캐시에 이미 데이터가 있으면 바로 반환
    if (_imageCache.containsKey(modirId)) {
      log('Returning cached images for modir_id $modirId: ${_imageCache[modirId]}');
      return _imageCache[modirId]!;
    }

    try {
      print('Fetching images from Supabase for modir_id $modirId');
      final response = await supabase
          .from('modir_images')
          .select('image_url')
          .eq('modir_id', modirId);

      print('Supabase response for modir_id $modirId: $response');

      if (response.isNotEmpty) {
        final imageUrls = response.map((row) => row['image_url'] as String).toList();
        _imageCache[modirId] = imageUrls; // 캐시에 저장
        print('Fetched and cached images for modir_id $modirId: $imageUrls');
        return imageUrls;
      } else {
        print('No images found for modir_id $modirId');
        _imageCache[modirId] = []; // 빈 리스트 캐싱
        return [];
      }
    } catch (e) {
      print('Error fetching images for modir_id $modirId: $e');
      return [];
    }
  }

  // 캐시 초기화 메서드 (디버깅용)
  void clearCache() {
    _imageCache.clear();
    print('Image cache cleared');
  }
}