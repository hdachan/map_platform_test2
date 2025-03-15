import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

/// HTML 태그 제거 함수
String removeHtmlTags(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>'), '');
}

/// 1️⃣ 현재 위치 가져오기
Future<Position?> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }

  if (permission == LocationPermission.deniedForever) return null;

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

/// 2️⃣ POI 검색 (현재 위치에서 가까운 건물명 가져오기)
/// 2️⃣ POI 검색 (현재 위치에서 가까운 건물명 또는 도로명 주소 가져오기)
Future<String?> getPOIFromCoordinates(double lat, double lng) async {
  final url = Uri.parse(
      'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lng,$lat&output=json&orders=roadaddr,addr,legalcode'
  );

  try {
    final response = await http.get(url, headers: {
      'X-NCP-APIGW-API-KEY-ID': 'uswn3r8t9u',
      'X-NCP-APIGW-API-KEY': 'RegnFf3T7Xky0B7yJUispTLN4Z53eo2Bbs5wkvKU',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        final result = data['results'][0];  // 첫 번째 검색 결과

        // 1️⃣ 도로명 주소 확인
        String? roadAddress = result['land']?['name'];
        String? roadNumber = result['land']?['number1'];
        String? fullRoadAddress = roadAddress != null && roadNumber != null
            ? "$roadAddress $roadNumber"
            : null;

        // 2️⃣ 건물명 확인 (건물명보다 도로명 주소가 우선)
        String? buildingName = result['land']?['addition0']?['value'];

        return fullRoadAddress ?? buildingName ?? "현재 위치";
      }
    }
  } catch (e) {
    print("🚨 POI 검색 오류: $e");
  }
  return "현재 위치";
}





/// 3️⃣ 네이버 장소 검색 (도착지 POI 정보 가져오기)
Future<Map<String, dynamic>?> getPlaceDetails(String query) async {
  final url = Uri.parse(
      'https://openapi.naver.com/v1/search/local.json?query=${Uri.encodeComponent(query)}&display=1'
  );

  try {
    final response = await http.get(url, headers: {
      'X-Naver-Client-Id': 'uswn3r8t9u',
      'X-Naver-Client-Secret': 'RegnFf3T7Xky0B7yJUispTLN4Z53eo2Bbs5wkvKU',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return data['items'][0];
      }
    }
  } catch (e) {
    print("🚨 장소 검색 오류: $e");
  }
  return null;
}

/// 4️⃣ TM 좌표 -> WGS84 변환 함수
Map<String, double> convertTMtoWGS84(double mapx, double mapy) {
  double wgs84Lng = (mapx - 309000) * 0.0000089 + 126.0;
  double wgs84Lat = (mapy - 547000) * 0.0000089 + 37.0;
  return {"lat": wgs84Lat, "lng": wgs84Lng};
}

/// 5️⃣ 네이버 길찾기 실행
Future<void> navigateToDestination(double latitude, double longitude, String destinationName) async {
  try {
    // 현재 위치 가져오기
    Position? currentPosition = await getCurrentLocation();
    if (currentPosition == null) {
      print("⚠️ 위치 정보를 가져올 수 없음");
      return;
    }

    // 출발지 POI 검색
    String startName = (await getPOIFromCoordinates(currentPosition.latitude, currentPosition.longitude)) ?? "현재 위치";

// 네이버 장소 검색 API에서 도착지 정보 가져오기
    final placeDetails = await getPlaceDetails(destinationName);
    if (placeDetails != null) {
      destinationName = removeHtmlTags(placeDetails['title'] ?? ""); // ✅ 기본값 "" 추가
      double mapx = double.tryParse(placeDetails['mapx']) ?? 0.0;
      double mapy = double.tryParse(placeDetails['mapy']) ?? 0.0;
      final converted = convertTMtoWGS84(mapx, mapy);
      latitude = converted["lat"]!;
      longitude = converted["lng"]!;
    }
    // 좌표 값 포맷팅
    double startLat = double.parse(currentPosition.latitude.toStringAsFixed(7));
    double startLng = double.parse(currentPosition.longitude.toStringAsFixed(7));
    double endLat = double.parse(latitude.toStringAsFixed(7));
    double endLng = double.parse(longitude.toStringAsFixed(7));

    print("🚀 출발지: $startName ($startLat, $startLng)");
    print("🏁 도착지: $destinationName ($endLat, $endLng)");

    // 네이버 지도 앱 URL (도보 모드)
    final appUrl = Uri.parse(
      "navermap://route/walk?"
          "slat=$startLat&slng=$startLng&"
          "sname=${Uri.encodeComponent(startName)}&"
          "dlat=$endLat&dlng=$endLng&"
          "dname=${Uri.encodeComponent(destinationName)}&"
          "appname=com.example.untitled114",
    );

    print("🔗 네이버 지도 앱 URL: $appUrl");

    // 네이버 지도 웹 URL (앱 실행 실패 시)
    final webUrl = Uri.parse(
        "https://map.naver.com/v5/directions/"
            "$startLat,$startLng,${Uri.encodeComponent(startName)}/"
            "$endLat,$endLng,${Uri.encodeComponent(destinationName)}"
    );

    // 네이버 지도 앱 실행 시도, 불가능하면 웹으로 이동
    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl);
    } else {
      print("⚠️ 네이버 지도 앱 실행 실패, 웹 브라우저로 이동");
      await launchUrl(webUrl);
    }
  } catch (e) {
    print("🚨 길찾기 실행 오류: $e");
  }
}


