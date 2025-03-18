import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled114/services/supabase_service.dart';

class AuthService extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
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
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser; // 현재 사용자 정보 저장

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  // 앱 시작 시 세션 복원 및 사용자 상태 확인
  Future<bool> checkSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        _currentUser = Supabase.instance.client.auth.currentUser;
        notifyListeners();
        return true; // 세션이 유효함
      }
      return false; // 세션이 없음
    } catch (error) {
      print('Error checking session: $error');
      return false;
    }
  }

  Future<String?> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return '이메일과 비밀번호를 모두 입력해주세요.';
    }

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
      _currentUser = user; // 로그인 성공 시 사용자 정보 저장
      notifyListeners();
      return null; // 로그인 성공
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return _errorMessage;
    }
  }

  // 로그아웃 메서드 추가 (필요 시)
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}