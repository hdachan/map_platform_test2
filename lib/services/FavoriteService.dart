import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 관심 등록 여부 확인
  Future<bool> isFavoriteStore(String userId, int storeId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('store_id', storeId);

      return response.isNotEmpty; // 결과가 있으면 true, 없으면 false
    } catch (e) {
      print('❌ 관심 등록 여부 확인 실패: $e');
      return false; // 오류 발생 시 기본값 false 반환
    }
  }

  // 관심 매장 등록
  Future<bool> addFavorite(String userId, int storeId) async {
    try {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'store_id': storeId,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('✅ 관심 매장 등록 성공: storeId = $storeId');
      return true;
    } catch (e) {
      print('❌ 관심 매장 등록 실패: $e');
      return false;
    }
  }

  // 관심 매장 해제
  Future<void> removeFavorite(String userId, int storeId) async {
    try {
      print('🗑 삭제 요청: user_id = $userId, store_id = $storeId');

      final response = await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)  // ← UUID로 변환 필요할 수도 있음
          .eq('store_id', storeId);

      print('🔍 DELETE Response: $response');

      if (response == null || response.isEmpty) {
        print('❌ 삭제 실패: 응답이 없음');
      } else {
        print('✅ 관심 매장 삭제 성공: storeId = $storeId');
      }
    } catch (e) {
      print('❌ 관심 매장 삭제 중 오류 발생: $e');
    }
  }


}


class FavoriteButton extends StatefulWidget {
  final int storeId;

  const FavoriteButton({Key? key, required this.storeId}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false; // 관심 등록 여부
  final favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  // 관심 등록 여부 불러오기
  Future<void> _loadFavoriteStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    bool favorite = await favoriteService.isFavoriteStore(user.id, widget.storeId);
    setState(() {
      isFavorite = favorite;
    });
  }

  // 관심 매장 추가/삭제
  Future<void> _toggleFavorite() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print("로그인이 필요합니다.");
      return;
    }

    if (isFavorite) {
      await favoriteService.removeFavorite(user.id, widget.storeId);
      print("관심 매장에서 제거되었습니다.");
    } else {
      await favoriteService.addFavorite(user.id, widget.storeId);
      print("관심 매장으로 등록되었습니다.");
    }

    // 상태 업데이트 (UI 반영)
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_outline, // 상태에 따라 아이콘 변경
        color: isFavorite ? Colors.red : Colors.grey, // 상태에 따라 색상 변경
        size: 20.sp,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
