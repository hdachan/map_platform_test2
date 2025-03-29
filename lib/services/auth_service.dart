import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled114/services/supabase_service.dart';

class AuthService {
  final _supabaseService = SupabaseService();
  final _emailCache = <String, bool>{};


  Future<bool> validateAndCheckEmail(String email) async {
    email = email.trim().toLowerCase();
    if (email.isEmpty) {
      throw Exception('이메일 주소를 입력하세요.');
    }
    if (email.length > 254) {
      throw Exception('이메일은 254자를 넘을 수 없습니다.');
    }

    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(email)) {
      throw Exception('유효한 이메일 주소를 입력하세요.');
    }

    if (_emailCache.containsKey(email)) {
      if (!_emailCache[email]!) {
        throw Exception('이미 등록된 이메일입니다.');
      }
      return true;
    }

    try {
      final response = await Supabase.instance.client
          .from('userinfo')
          .select('id')
          .eq('email', email)
          .maybeSingle()
          .timeout(Duration(seconds: 10));

      final isAvailable = response == null;
      _emailCache[email] = isAvailable;
      if (!isAvailable) {
        throw Exception('이미 등록된 이메일입니다.');
      }
      return true;
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('네트워크가 느립니다.');
      } else if (e is PostgrestException) {
        throw Exception('서버 오류: ${e.message}');
      } else {
        throw Exception('이메일 확인에 실패했습니다.');
      }
    }
  }

  Future<User?> checkSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        return Supabase.instance.client.auth.currentUser;
      }
      return null;
    } catch (e) {
      throw Exception('세션 확인 오류: $e');
    }
  }

  Future<User?> signIn(String email, String password) async {
    email = email.trim();
    if (email.isEmpty || password.isEmpty) {
      throw Exception('이메일과 비밀번호를 입력하세요.');
    }

    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );
    if (!emailRegExp.hasMatch(email)) {
      throw Exception('유효한 이메일 주소를 입력해주세요.');
    }

    try {
      final user = await _supabaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user == null) {
        throw Exception('로그인 실패: 사용자 정보를 확인할 수 없습니다.');
      }
      return user;
    } catch (e) {
      throw Exception('$e'.replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}