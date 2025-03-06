import 'package:supabase_flutter/supabase_flutter.dart';

class InformationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
    required String birthdate,
    required bool gender,
    required String category,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        await _supabase.from('userinfo').upsert({
          'id': userId,
          'email': email,
          'username': username,
          'birthdate': birthdate,
          'gender': gender,
          'category': category,
        });

        return userId; // 성공 시 userId 반환
      }
      return null; // 실패 시 null 반환
    } catch (e) {
      throw Exception('회원가입 오류: $e');
    }
  }
}