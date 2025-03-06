import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../utils/designSize.dart';
import '../viewmodels/map_viewmodel.dart';
import '../viewmodels/data_viewmodel.dart';

import '../utils/marker_helper.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/custom_button.dart';
import 'home_navermap_filter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  NaverMapController? _mapController;
  bool _showRefreshButton = false;
  String? _selectedMarkerTitle;

  /// 📌 마커 업데이트 함수
  void _updateMarkers(DataViewModel dataProvider) {
    setState(() {
      updateMarkers(
          _mapController,
          dataProvider,
          _selectedMarkerTitle,
              (modir) {
            /// ✅ `setState()` 실행 후 UI가 즉시 반영되도록 `Future.microtask()` 사용
            setState(() {
              _selectedMarkerTitle = modir.title;
            });
            Future.microtask(() => _updateMarkers(dataProvider));  // ✅ 마커 즉시 갱신
            showMarkerBottomSheet(
                context, '', '', '', modir.title, modir.latitude, modir.longitude, modir.id
            );
          },
              () {
            showCenteredSnackbar(context, "검색된 마커가 없습니다.");
          }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Consumer2<MapProvider, DataViewModel>(
                builder: (context, mapProvider, dataProvider, child) {
                  return Column(
                    children: [
                      LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return Container(
                            width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                            height: 48.h,
                            padding: const EdgeInsets.only(top: 6, bottom: 6),
                            child: Container(
                              width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                              height: 36.h,
                              padding: const EdgeInsets.only(right: 16, left: 16),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print("검색 클릭됨");
                                    },
                                    child: Container(
                                      width: ResponsiveUtils.getResponsiveWidth(284, 360, constraints),
                                      height: 36.h,
                                      padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF3D3D3D),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: ResponsiveUtils.getResponsiveWidth(20, 360, constraints),
                                            height: 20.h,
                                            child:  Icon(
                                              Icons.search,
                                              color: Color(0xFF888888),
                                              size: 20.sp,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Container(
                                            width: ResponsiveUtils.getResponsiveWidth(236, 360, constraints),
                                            height: 20.h,
                                            child:  Text(
                                              '매장, 위치 검색',
                                              style: TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 14.sp,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                height: 1.40,
                                                letterSpacing: -0.35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Filter()),
                                      );
                                    },
                                    child: Container(
                                      width: ResponsiveUtils.getResponsiveWidth(36, 360, constraints),
                                      height: 36.h,
                                      padding: const EdgeInsets.all(6),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child:  Center(
                                        child: Icon(
                                          Icons.filter_list,
                                          size: 24.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      /// 🗺️ 네이버 지도 & 새로고침 버튼 (Stack 적용)
                      Stack(
                        children: [
                          Container(
                            height: 600.h,
                            width: double.infinity,
                            child: NaverMap(
                              onMapReady: (controller) {
                                _mapController = controller;
                                _updateMarkers(dataProvider);
                              },
                              onCameraChange: (NCameraUpdateReason reason, bool animated) {
                                if (reason == NCameraUpdateReason.gesture) {
                                  if (!_showRefreshButton) {
                                    setState(() {
                                      _showRefreshButton = true;
                                    });
                                  }
                                }
                              },
                              options: const NaverMapViewOptions(
                                initialCameraPosition: NCameraPosition(
                                  target: NLatLng(36.1234229, 128.1146402),
                                  zoom: 15,
                                  bearing: 0,
                                  tilt: 0,
                                ),
                                logoAlign: NLogoAlign.rightTop,
                                logoMargin: EdgeInsets.only(top: 16, right: 16),
                              ),
                            ),
                          ),
                          /// 🔄 새로고침 버튼
                          if (_showRefreshButton)
                            RefreshButton(
                              onTap: () {
                                setState(() {
                                  _showRefreshButton = false;
                                });
                                _updateMarkers(dataProvider);
                              },
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }


}
