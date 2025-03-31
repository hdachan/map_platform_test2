import 'dart:developer';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

Future<void> moveToCurrentLocation(
    NaverMapController? mapController,
    ) async {
  if (mapController == null) {
    log("MapController가 아직 설정되지 않음!");
    return;
  }

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    log("위치 서비스가 비활성화되어 있음.");
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      log("위치 권한이 영구적으로 거부되었습니다.");
      return;
    }
  }

  try {
    // LocationSettings를 사용해 위치 설정 지정
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // 높은 정확도 설정
        distanceFilter: 0, // 위치 업데이트 간 최소 거리 (0 = 모든 업데이트 수신)
      ),
    );

    log("현재 위치: ${position.latitude}, ${position.longitude}");

    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
      target: NLatLng(position.latitude, position.longitude),
      zoom: 15,
    );

    await mapController.updateCamera(cameraUpdate);
    log("현재 위치로 이동 완료!");
  } catch (e) {
    log("위치 정보를 가져오는 중 오류 발생: $e");
  }
}