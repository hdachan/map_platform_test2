import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../models/modir.dart';
import '../viewmodels/data_viewmodel.dart';

/// 📌 마커 리스트 생성
Set<NAddableOverlay> buildMarkersFromList(
    List<Modir> dataList,
    String? selectedMarkerTitle,
    Function(Modir) onMarkerTap) {

  return dataList.map<NAddableOverlay>((modir) {
    final bool isSelected = (modir.title == selectedMarkerTitle);

    final String iconPath = isSelected
        ? 'assets/image/maker_on.png' // ✅ 선택된 마커 이미지
        : 'assets/image/marker_off.png'; // ✅ 기본 마커 이미지

    final marker = NMarker(
      id: modir.title,
      position: NLatLng(modir.latitude, modir.longitude),
      caption: NOverlayCaption(text: modir.title),
      icon: NOverlayImage.fromAssetImage(iconPath),
      size:  Size(30, 30),
    );

    marker.setOnTapListener((overlay) {
      onMarkerTap(modir);
    });

    return marker;
  }).toSet();
}

/// 📌 마커 업데이트 (오류 수정)
Future<void> updateMarkers(
    NaverMapController? mapController,
    DataViewModel dataProvider,
    String? selectedMarkerTitle,
    Function(Modir) onMarkerTap,
    Function() showSnackbar) async {

  if (mapController == null) return;

  try {
    final bounds = await mapController.getContentBounds();

    final filteredData = dataProvider.dataList.where((modir) {
      return modir.latitude >= bounds.southWest.latitude &&
          modir.latitude <= bounds.northEast.latitude &&
          modir.longitude >= bounds.southWest.longitude &&
          modir.longitude <= bounds.northEast.longitude;
    }).toList();

    final newMarkers = buildMarkersFromList(filteredData, selectedMarkerTitle, onMarkerTap);

    // ✅ 기존 마커 삭제 후 새 마커 추가
    await mapController.clearOverlays();
    if (newMarkers.isEmpty) {
      showSnackbar();
    } else {
      await mapController.addOverlayAll(newMarkers);
    }
  } catch (e) {
    log("마커 업데이트 중 오류 발생: $e");
  }
}

