import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../views/login_Information_Screen.dart';

/// 로그인 관련 로직

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


/// 비밀번호 화면 로직
class PasswordViewModel extends ChangeNotifier {
  String? _errorMessage;
  String _password = '';

  String? get errorMessage => _errorMessage;
  String get password => _password;

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  bool hasCombination() {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*])').hasMatch(_password);
  }

  bool isLongEnough() {
    return _password.length >= 8;
  }

  bool hasNoConsecutiveChars() {
    if (_password.isEmpty) return false; // 빈 문자열일 때 false 반환
    for (int i = 0; i < _password.length - 1; i++) {
      if (_password[i] == _password[i + 1]) return false;
    }
    return true;
  }

  String? validatePasswords(String password, String confirmPassword) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else if (password != confirmPassword) {
      return '비밀번호가 일치하지 않습니다';
    } else if (!hasCombination() || !isLongEnough() || !hasNoConsecutiveChars()) {
      return '비밀번호 조건을 모두 충족해야 합니다';
    }
    return null;
  }

  void navigateToNextScreen(
      String email, String password, String confirmPassword, BuildContext context) {
    final error = validatePasswords(password, confirmPassword);
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
    } else {
      _errorMessage = null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InformationScreen(
            email: email,
            password: password,
          ),
        ),
      );
    }
  }
}