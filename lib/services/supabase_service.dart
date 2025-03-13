import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/modir.dart';

/// 데이터 불러오기
class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // 로그인 시도
  Future<User?> signInWithEmailAndPassword({required String email, required String password,}) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (error) {
      String errorMessage;
      switch (error.statusCode) {
        case 403:
          errorMessage = '접근이 금지되었습니다. 해당 기능을 사용할 수 없습니다.';
          break;
        case 422:
          errorMessage = '요청을 처리할 수 없습니다. 입력값을 확인해주세요.';
          break;
        case 429:
          errorMessage = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
          break;
        case 500:
          errorMessage = '내부 서버 오류가 발생했습니다. 고객센터로 문의하세요.';
          break;
        case 501:
          errorMessage = '요청한 기능이 구현되지 않았습니다.';
          break;
        default:
          errorMessage = error.message;
      }
      throw Exception(errorMessage); // 호출자에게 예외 전달
    } catch (error) {
      throw Exception('로그인 실패: $error');
    }
  }

  // modir 데이터 가져오기
  Future<List<Modir>> fetchModirData() async {
    try {
      final response = await client.from('modir').select();
      return (response as List<dynamic>)
          .map((json) => Modir.fromJson(json))
          .toList();
    } catch (error) {
      print('Error fetching modir data: $error');
      throw error;
    }
  }

  Future<List<Modir>> fetchModirDataInBounds(NLatLngBounds bounds) async {
    try {
      print('Fetching data with bounds: SW(${bounds.southWest.latitude}, ${bounds.southWest.longitude}), NE(${bounds.northEast.latitude}, ${bounds.northEast.longitude})');
      final response = await client
          .from('modir')
          .select()
          .gte('mapy', bounds.southWest.latitude)
          .lte('mapy', bounds.northEast.latitude)
          .gte('mapx', bounds.southWest.longitude)
          .lte('mapx', bounds.northEast.longitude);

      print('Fetched raw response: $response');
      if (response.isEmpty) {
        print('No data found in bounds - check bounds or database');
      } else {
        print('Data found: ${response.length} items');
      }

      return (response as List<dynamic>)
          .map((json) => Modir.fromJson(json))
          .toList();
    } catch (error) {
      print('Error fetching modir data in bounds: $error');
      rethrow;
    }
  }



  // 실시간 구독 설정
  RealtimeChannel setupRealtimeSubscription(
      String channelName, Function(PostgresChangePayload) callback) {
    return client.channel(channelName).onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'modir',
      callback: callback,
    ).subscribe();
  }
}