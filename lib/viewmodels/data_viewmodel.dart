// lib/viewmodels/data_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/modir.dart';
import '../services/supabase_service.dart';


// 마커 데이터 관리
class DataViewModel with ChangeNotifier {
  final SupabaseService _supabaseService;
  List<Modir> dataList = [];
  bool isLoading = false;
  String? errorMessage;
  RealtimeChannel? _realtimeChannel;

  DataViewModel({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService() {
    setupRealtimeSubscription();
    fetchData(); // 초기 데이터 로드
  }

  // 데이터 불러오기
  Future<void> fetchData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dataList = await _supabaseService.fetchModirData();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 실시간 구독 설정
  void setupRealtimeSubscription() {
    _realtimeChannel = _supabaseService.setupRealtimeSubscription(
      'modir_channel',
          (payload) {
        fetchData(); // 데이터 변경 시 갱신
      },
    );
  }

  // 리소스 정리
  void disposeProvider() {
    _realtimeChannel?.unsubscribe();
  }

  @override
  void dispose() {
    disposeProvider();
    super.dispose();
  }
}