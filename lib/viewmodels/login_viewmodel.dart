import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AuthViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 로그인 시도 후 에러 메시지를 반환 (성공 시 null 반환)
  Future<String?> signIn(String email, String password) async {
    // 빈 칸 검사
    if (email.isEmpty || password.isEmpty) {
      return '이메일과 비밀번호를 모두 입력해주세요.';
    }

    // 간단한 이메일 형식 검사
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );
    if (!emailRegex.hasMatch(email)) {
      return '유효한 이메일 주소를 입력해주세요.';
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _supabaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      if (user == null) {
        _errorMessage = '로그인 실패: 사용자 정보를 확인할 수 없습니다.';
        notifyListeners();
        return _errorMessage;
      }
      notifyListeners();
      return null; // 로그인 성공
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return _errorMessage;
    }
  }
}