import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchUserInfo(String userId) async {
    try {
      final response = await supabase.from('userinfo').select().eq('id', userId).single();
      return response;
    } catch (e) {
      print('사용자 정보 조회 오류: $e');
      return null;
    }
  }

  Future<bool> updateUserInfo(String userId, Map<String, dynamic> data) async {
    try {
      await supabase.from('userinfo').update(data).eq('id', userId);
      return true;
    } catch (e) {
      print('사용자 정보 업데이트 오류: $e');
      return false;
    }
  }
}
