import 'package:flutter/material.dart';


/// 바텀바 관련 로직
class SettingState extends ChangeNotifier {
  // 현재 선택된 하단바 인덱스
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  // 하단바 인덱스 변경 메서드
  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
