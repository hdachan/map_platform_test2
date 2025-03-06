// 필터 상태관리
import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  final List<String> _selectedFilters = [];

  List<String> get selectedFilters => _selectedFilters;

  /// 필터 토글 (이미 선택되어 있으면 제거, 없으면 추가)
  void toggleFilter(String filter) {
    if (_selectedFilters.contains(filter)) {
      _selectedFilters.remove(filter);
    } else {
      _selectedFilters.add(filter);
    }
    notifyListeners();
  }

  /// 특정 필터 제거
  void removeFilter(String filter) {
    _selectedFilters.remove(filter);
    notifyListeners();
  }
}