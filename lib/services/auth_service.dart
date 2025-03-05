import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // 이메일 형식 유효성 검사
  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  // 이메일 중복 검사
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await Supabase.instance.client
          .from('userinfo')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      return response == null; // null이면 중복되지 않음
    } catch (error) {
      print('Error checking email availability: $error');
      return false;
    }
  }

  // 회원가입 시도 (필요 시 사용)
  Future<User?> signUp(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } catch (error) {
      print('Error signing up: $error');
      return null;
    }
  }
}