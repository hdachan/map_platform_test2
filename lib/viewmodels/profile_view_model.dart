import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///사용자 정보 수정하기
class ProfileViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedGenderIndex = -1;
  int _selectedCategoryIndex = -1;

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedGenderIndex => _selectedGenderIndex;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  TextEditingController get nicknameController => _nicknameController;
  TextEditingController get birthdateController => _birthdateController;

  void onGenderButtonPressed(int index) {
    _selectedGenderIndex = index;
    notifyListeners();
  }

  void onCategoryButtonPressed(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  Future<void> fetchUserInfo() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _errorMessage = '로그인이 필요합니다.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('userinfo')
          .select()
          .eq('id', user.id)
          .single();

      if (response != null) {
        _nicknameController.text = response['username'] ?? '';
        _birthdateController.text = response['birthdate'] ?? '';
        _selectedGenderIndex = response['gender'] == true ? 0 : (response['gender'] == false ? 1 : -1);
        _selectedCategoryIndex = response['category'] == '빈티지'
            ? 0
            : (response['category'] == '아메카지' ? 1 : -1);
      } else {
        _errorMessage = '사용자 정보를 찾을 수 없습니다.';
      }
    } catch (e) {
      _errorMessage = '정보 조회 중 오류 발생: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserInfo() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await Supabase.instance.client.from('userinfo').update({
        'username': _nicknameController.text.trim(),
        'birthdate': _birthdateController.text.trim(),
        'gender': _selectedGenderIndex == 0 ? true : (_selectedGenderIndex == 1 ? false : null),
        'category': _selectedCategoryIndex == 0 ? '빈티지' : (_selectedCategoryIndex == 1 ? '아메카지' : null),
      }).eq('id', user.id);
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }
}
