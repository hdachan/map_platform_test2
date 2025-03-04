// lib/config/app_config.dart
import 'package:flutter_naver_map/flutter_naver_map.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://ceckhzfboykmsshamikv.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlY2toemZib3lrbXNzaGFtaWt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg0MDU1NTYsImV4cCI6MjA1Mzk4MTU1Nn0.jFJxTniyNAq2cmDrYqFyZYvBVAQFVfkhOhHSms1f_Uk';
}
class AppConfig {
  static Future<void> initializeApp() async {
    try {
      await NaverMapSdk.instance.initialize(
        clientId: 'uswn3r8t9u', // 올바른 ID로 교체
        onAuthFailed: (ex) {
          print("********* 네이버맵 인증오류 : $ex *********");
        },
      );
      print("네이버 맵 SDK 초기화 성공");
    } catch (e) {
      print("네이버 맵 초기화 중 오류 발생: $e");
    }
  }
}