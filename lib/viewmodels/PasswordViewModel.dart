import 'package:flutter/material.dart';
import '../views/login_Information_Screen.dart';

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