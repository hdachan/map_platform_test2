import 'package:flutter/material.dart';
import '../services/information_service.dart';

class InformationViewModel extends ChangeNotifier {
  final InformationService _authService = InformationService(); // 이름 변경

  bool _isTextFieldEmpty = true;
  bool _isTextFieldEmpty1 = true;
  int _selectedGenderIndex = -1;
  int _selectedCategoryIndex = -1;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  bool get isNicknameEmpty => _isTextFieldEmpty;
  bool get isBirthdateEmpty => _isTextFieldEmpty1;
  int get selectedGenderIndex => _selectedGenderIndex;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  TextEditingController get nicknameController => _nicknameController;
  TextEditingController get birthdateController => _birthdateController;

  InformationViewModel() {
    _nicknameController.addListener(() {
      _isTextFieldEmpty = _nicknameController.text.isEmpty;
      notifyListeners();
    });
    _birthdateController.addListener(() {
      _isTextFieldEmpty1 = _birthdateController.text.isEmpty;
      notifyListeners();
    });
  }

  void onGenderButtonPressed(int index) {
    _selectedGenderIndex = index;
    notifyListeners();
  }

  void onCategoryButtonPressed(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  Future<String?> signUp(String email, String password) async {
    if (_nicknameController.text.trim().isEmpty) return '닉네임을 입력해주세요.';
    if (_birthdateController.text.trim().isEmpty) return '생년월일을 입력해주세요.';
    if (_selectedGenderIndex == -1) return '성별을 선택해주세요.';
    if (_selectedCategoryIndex == -1) return '카테고리를 선택해주세요.';

    try {
      final userId = await _authService.signUp(
        email: email,
        password: password,
        username: _nicknameController.text.trim(),
        birthdate: _birthdateController.text.trim(),
        gender: _selectedGenderIndex == 0,
        category: _selectedCategoryIndex == 0 ? '빈티지' : '아메카지',
      );
      return userId != null ? null : '회원가입 실패. 다시 시도해주세요.';
    } catch (e) {
      return '오류 발생: $e';
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }
}