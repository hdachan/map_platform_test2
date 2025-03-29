import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../views/login_Information_Screen.dart';
import 'package:untitled114/services/auth_service.dart';

/// 로그인 관련 로직
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  AuthViewModel(this._authService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  Future<bool> validateAndCheckEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.validateAndCheckEmail(email);
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.checkSession();
      _isLoading = false;
      _currentUser = user;
      print('checkSession: user = ${user?.id}'); // 디버깅용
      notifyListeners();
      return user != null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('checkSession error: $e'); // 디버깅용
      notifyListeners();
      return false;
    }
  }

  Future<String?> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signIn(email, password);
      _isLoading = false;
      _currentUser = user;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return _errorMessage;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signOut();
      _isLoading = false;
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }
}

/// 비밀번호 화면 로직
class PasswordViewModel extends ChangeNotifier {
  String _password = '';
  String _confirmPassword = '';
  String? _errorMessage;

  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String? get errorMessage => _errorMessage;

  void updatePassword(String value) {
    _password = value;
    _errorMessage = validatePasswords(_password, _confirmPassword);
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    _errorMessage = validatePasswords(_password, _confirmPassword);
    notifyListeners();
  }

  bool hasCombination() => RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*])').hasMatch(_password);
  bool isLongEnough() => _password.length >= 8;
  bool hasNoConsecutiveChars() {
    if (_password.isEmpty) return false;
    for (int i = 0; i < _password.length - 2; i++) {
      if (_password[i] == _password[i + 1] && _password[i] == _password[i + 2]) return false;
    }
    return true;
  }
  bool passwordsMatch() => _password == _confirmPassword && _password.isNotEmpty;

  String? validatePasswords(String password, String confirmPassword) {
    if (password.isEmpty || confirmPassword.isEmpty) return '비밀번호를 입력해주세요';
    if (password != confirmPassword) return '비밀번호가 일치하지 않습니다';
    if (!hasCombination() || !isLongEnough() || !hasNoConsecutiveChars()) return '비밀번호 조건을 모두 충족해야 합니다';
    return null;
  }

  void navigateToNextScreen(String email, String password, String confirmPassword, BuildContext context) {
    final error = validatePasswords(password, confirmPassword);
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
    } else {
      _errorMessage = null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InformationScreen(email: email, password: password),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}