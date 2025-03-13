import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../utils/designSize.dart';
import '../viewmodels/data_viewmodel.dart';
import '../utils/marker_helper.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/custom_button.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  NaverMapController? _mapController;
  bool _showRefreshButton = false;
  String? _selectedMarkerTitle;
  double _sheetExtent = 0.2;
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Color(0xFF1A1A1A),
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // 필터 제목
            Container(
              padding: EdgeInsets.only(left: 16,right: 16),
              child:      Text(
                '지역선택',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.10,
                  letterSpacing: -0.45,
                ),
              ),
            ),

            Container(
              width: 360.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xFF3D3D3D)), // 아래쪽 테두리
                ),
              ),

              child: Row(
                children: [
                  Container(
                    width: 120.w,
                    height: 16.h,
                    child: Text(
                      '시/도',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                        letterSpacing: -0.30,
                      ),
                    ),
                  ),
                  Container(
                    width: 240.w,
                    height: 16.h,
                    child: Text(
                      '상세보기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                        letterSpacing: -0.30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 필터 옵션 리스트 (예시)
            Expanded(
              child: ListView(
                children: [
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // 적용 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 바텀시트 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF05FFF7),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '적용',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// 필터 옵션 위젯
  Widget _buildFilterOption(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

// 필터 적용 로직
  void _applyFilter(BuildContext context, String region) {
    final dataProvider = Provider.of<DataViewModel>(context, listen: false);
    // 여기서 필터 적용 로직 추가 (예: 지역에 맞는 데이터만 로드)
    print('Selected region: $region');
    // 예: dataProvider.fetchDataInBounds(bounds, region: region);
    Navigator.pop(context); // 선택 후 바텀시트 닫기
  }

  Future<void> _moveToCurrentLocation() async {
    print("버튼이 눌렸습니다!");

    if (_mapController == null) {
      print("MapController가 아직 설정되지 않음!");
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치 서비스가 비활성화되어 있음.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("위치 권한이 영구적으로 거부되었습니다.");
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("현재 위치: ${position.latitude}, ${position.longitude}");

      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(position.latitude, position.longitude),
        zoom: 15,
      );

      await _mapController!.updateCamera(cameraUpdate);
      print("현재 위치로 이동 완료!");
    } catch (e) {
      print("위치 정보를 가져오는 중 오류 발생: $e");
    }
  }

  void _updateMarkers(DataViewModel dataProvider) {
    print('Markers to update:');
    print('dataProvider.dataList length: ${dataProvider.dataList.length}');
    for (var modir in dataProvider.dataList) {
      print(
          'ID: ${modir.id}, Title: ${modir.title}, Lat: ${modir.latitude}, Lon: ${modir.longitude}');
    }
    updateMarkers(
      _mapController,
      dataProvider,
      _selectedMarkerTitle,
          (modir) {
        setState(() {
          _selectedMarkerTitle = modir.title;
        });
        Future.microtask(() => _updateMarkers(dataProvider));
        // showMarkerBottomSheet 호출 전에 시트 크기를 minChildSize(0.2)로 설정
        _sheetController.animateTo(
          0.2,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        showMarkerBottomSheet(
          context,
          '',
          '',
          '',
          modir.title,
          modir.latitude,
          modir.longitude,
          modir.id,
        );
      },
          () {
        showCenteredSnackbar(context, "검색된 마커가 없습니다.");
      },
    );
  }

  // 검색 버튼 클릭 시 데이터와 마커 업데이트
  void _onSearchPressed(DataViewModel dataProvider) async {
    final bounds = await _mapController?.getContentBounds();
    if (bounds != null) {
      print(
          'Search triggered, bounds: SW(${bounds.southWest.latitude}, ${bounds.southWest.longitude}), NE(${bounds.northEast.latitude}, ${bounds.northEast.longitude})');
      await dataProvider.fetchDataInBounds(bounds);
      _updateMarkers(dataProvider);
      setState(() {
        _showRefreshButton = false; // 검색 후 버튼 숨김
      });
    } else {
      print('Bounds is null on search');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double sheetTop = screenHeight * (1 - _sheetExtent);
    double buttonTop = sheetTop - 180;

    return ChangeNotifierProvider(
      create: (_) => DataViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  // 검색창 영역
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        width: ResponsiveUtils.getResponsiveWidth(
                            360, 360, constraints),
                        height: 48.h,
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Container(
                          width: ResponsiveUtils.getResponsiveWidth(
                              360, 360, constraints),
                          height: 36.h,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  print("검색 클릭됨");
                                },
                                child: Container(
                                  width: ResponsiveUtils.getResponsiveWidth(
                                      284, 360, constraints),
                                  height: 36.h,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF3D3D3D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: const Color(0xFF888888),
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          '매장, 위치 검색',
                                          style: TextStyle(
                                            color: const Color(0xFF888888),
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
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Filter()),
                                  // );
                                },
                                child: Container(
                                  width: ResponsiveUtils.getResponsiveWidth(
                                      36, 360, constraints),
                                  height: 36.h,
                                  padding: const EdgeInsets.all(6),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Center(
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
                  Expanded(
                    child: Consumer<DataViewModel>(
                      builder: (context, dataProvider, child) {
                        print(
                            'Building UI with dataList length: ${dataProvider.dataList.length}');
                        return Stack(
                          children: [
                            NaverMap(
                              onMapReady: (controller) async {
                                _mapController = controller;
                                print('Map ready');
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  final bounds =
                                      await _mapController?.getContentBounds();
                                  if (bounds != null) {
                                    print(
                                        'Initial bounds: SW(${bounds.southWest.latitude}, ${bounds.southWest.longitude}), NE(${bounds.northEast.latitude}, ${bounds.northEast.longitude})');
                                    await dataProvider
                                        .fetchDataInBounds(bounds);
                                    _updateMarkers(dataProvider);
                                  } else {
                                    print('Initial bounds is null');
                                  }
                                });
                              },
                              onCameraChange: (position, reason) {
                                setState(() {
                                  _showRefreshButton = true; // 이동 시 버튼만 표시
                                });
                              },
                              onCameraIdle: () {
                                // 데이터 갱신 제거, 버튼 표시만 유지
                                print('Camera idle, waiting for search');
                              },
                              options: const NaverMapViewOptions(
                                initialCameraPosition: NCameraPosition(
                                  target: NLatLng(36.1234229, 128.1146402),
                                  zoom: 15,
                                ),
                              ),
                            ),
                            if (_showRefreshButton)
                              Positioned(
                                top: 20,
                                left: 118,
                                right: 118,
                                child: RefreshButton(
                                  onTap: () => _onSearchPressed(dataProvider),
                                ),
                              ),
                            NotificationListener<DraggableScrollableNotification>(
                              onNotification: (notification) {
                                setState(() {
                                  _sheetExtent = notification.extent;
                                });
                                return true;
                              },
                              child: DraggableScrollableSheet(
                                controller: _sheetController, // 컨트롤러 추가
                                initialChildSize: 0.2,
                                minChildSize: 0.2,
                                maxChildSize: 1.0,
                                builder: (BuildContext context, ScrollController scrollController) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    child: CustomScrollView(
                                      controller: scrollController,
                                      slivers: [
                                        SliverPersistentHeader(
                                          pinned: true,
                                          floating: false,
                                          delegate: _SliverAppBarDelegate(
                                            minHeight: 152.h,
                                            maxHeight: 152.h,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 360.w,
                                                  height: 24.h,
                                                  color: Color(0xFF1A1A1A),
                                                  child: Center(
                                                    child: Container(
                                                      width: 48.w,
                                                      height: 4.h,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 360.w,
                                                  height: 40.h,
                                                  color: Color(0xFF1A1A1A),
                                                  padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 231.w,
                                                        height: 20.h,
                                                        child: Text(
                                                          '핫플레이스가 궁금하다면 ?',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.sp,
                                                            fontFamily: 'Pretendard',
                                                            fontWeight: FontWeight.w700,
                                                            height: 1.10.h,
                                                            letterSpacing: -0.45,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      InkWell(
                                                        onTap: () {
                                                          _showFilterBottomSheet(context); // 바텀시트 표시 함수 호출
                                                        },
                                                        borderRadius: BorderRadius.circular(100), // 터치 피드백 모양 맞춤
                                                        child: Container(
                                                          width: 89.w,
                                                          height: 32.h,
                                                          padding: EdgeInsets.only(left: 12, right: 16, top: 8, bottom: 8),
                                                          decoration: ShapeDecoration(
                                                            shape: RoundedRectangleBorder(
                                                              side: BorderSide(width: 1, color: Color(0xFF888888)),
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(
                                                                Icons.location_on_outlined,
                                                                size: 16.sp,
                                                                color: Color(0xFF05FFF7),
                                                              ),
                                                              SizedBox(width: 4.w),
                                                              Text(
                                                                '지역선택',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12.sp,
                                                                  fontFamily: 'Pretendard',
                                                                  fontWeight: FontWeight.w700,
                                                                  height: 1.30,
                                                                  letterSpacing: -0.30,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 360.w,
                                                  height: 56.h,
                                                  color: Color(0xFF1A1A1A),
                                                  padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 77.w,
                                                        height: 32.h,
                                                        decoration: ShapeDecoration(
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                                            borderRadius: BorderRadius.circular(100),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 31.w,
                                                              height: 16.h,
                                                              child: Text(
                                                                '스타일',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12.sp,
                                                                  fontFamily: 'Pretendard',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 1.30,
                                                                  letterSpacing: -0.30,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 2.w),
                                                            Container(
                                                              width: 16.w,
                                                              height: 16.h,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.keyboard_arrow_down_outlined,
                                                                  size: 16.sp,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Container(
                                                        width: 77.w,
                                                        height: 32.h,
                                                        decoration: ShapeDecoration(
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                                            borderRadius: BorderRadius.circular(100),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 31.w,
                                                              height: 16.h,
                                                              child: Text(
                                                                '브랜드',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12.sp,
                                                                  fontFamily: 'Pretendard',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 1.30,
                                                                  letterSpacing: -0.30,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 2.w),
                                                            Container(
                                                              width: 16.w,
                                                              height: 16.h,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.keyboard_arrow_down_outlined,
                                                                  size: 16.sp,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Container(
                                                        width: 67.w,
                                                        height: 32.h,
                                                        decoration: ShapeDecoration(
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                                            borderRadius: BorderRadius.circular(100),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 21.w,
                                                              height: 16.h,
                                                              child: Text(
                                                                '매장',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12.sp,
                                                                  fontFamily: 'Pretendard',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 1.30,
                                                                  letterSpacing: -0.30,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 2.w),
                                                            Container(
                                                              width: 16.w,
                                                              height: 16.h,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.keyboard_arrow_down_outlined,
                                                                  size: 16.sp,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Container(
                                                        width: 67.w,
                                                        height: 32.h,
                                                        decoration: ShapeDecoration(
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                                            borderRadius: BorderRadius.circular(100),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 21.w,
                                                              height: 16.h,
                                                              child: Text(
                                                                '성별',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12.sp,
                                                                  fontFamily: 'Pretendard',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 1.30,
                                                                  letterSpacing: -0.30,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 2.w),
                                                            Container(
                                                              width: 16.w,
                                                              height: 16.h,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.keyboard_arrow_down_outlined,
                                                                  size: 16.sp,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 360.w,
                                                  height: 32.h,
                                                  color: Color(0xFF1A1A1A),
                                                  padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '총 ${dataProvider.dataList.length} 개의 매장',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp,
                                                          fontFamily: 'Pretendard',
                                                          fontWeight: FontWeight.w500,
                                                          height: 1.30,
                                                          letterSpacing: -0.30,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                                (context, index) {
                                              final modir = dataProvider.dataList[index];
                                              print('Building SliverList item $index: ${modir.title}');
                                              return Container(
                                                width: 360.w,
                                                height: 174.h,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF1A1A1A),
                                                  border: Border(
                                                    bottom: BorderSide(width: 1.w, color: Color(0xFF3D3D3D)),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 360.w,
                                                      height: 128.h,
                                                      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 212.w,
                                                            height: 108.h,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  modir.title,
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14.sp,
                                                                    fontFamily: 'Pretendard',
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.40,
                                                                    letterSpacing: -0.35,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 8.h),
                                                                Text(
                                                                  '영업 중 · 21:30에 영업 종료',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.sp,
                                                                    fontFamily: 'Pretendard',
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.30,
                                                                    letterSpacing: -0.30,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 8.h),
                                                                Text(
                                                                  '조회 · 1912명',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.sp,
                                                                    fontFamily: 'Pretendard',
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.30,
                                                                    letterSpacing: -0.30,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 8.h),
                                                                Text(
                                                                  '위도: ${modir.latitude}, 경도: ${modir.longitude}',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.sp,
                                                                    fontFamily: 'Pretendard',
                                                                    fontWeight: FontWeight.w500,
                                                                    height: 1.30,
                                                                    letterSpacing: -0.30,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 8.w),
                                                          Container(
                                                            width: 108.w,
                                                            height: 108.h,
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFF797777),
                                                              borderRadius: BorderRadius.circular(4),
                                                              image: DecorationImage(
                                                                image: AssetImage('assets/image/test_image.png'),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 360.w,
                                                      height: 44.h,
                                                      decoration: ShapeDecoration(
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(width: 1, color: Color(0xFF242424)),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Icon(Icons.favorite_outline, color: Colors.grey, size: 20.sp),
                                                          Icon(Icons.call_outlined, color: Colors.grey, size: 20.sp),
                                                          Icon(Icons.subdirectory_arrow_right_rounded, color: Colors.grey, size: 20.sp),
                                                          Icon(Icons.ios_share_outlined, color: Colors.grey, size: 20.sp),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            childCount: dataProvider.dataList.length,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (_sheetExtent >= 1.0)
                              Positioned(
                                bottom: 16.h, // 화면 하단에서 16.h 위에 위치
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // "지도보기" 버튼 클릭 시 시트 크기를 minChildSize(0.2)로 축소
                                      _sheetController.animateTo(
                                        0.2,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, // 버튼 배경색
                                      foregroundColor: Colors.black, // 텍스트 및 아이콘 색상
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    ),
                                    child: Text(
                                      '지도보기',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: buttonTop,
                              left: MediaQuery.of(context).size.width / 2 - 190,
                              child: GestureDetector(
                                onTap: _moveToCurrentLocation,
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: Color(0xB2242424),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 8,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.transparent,
                                    // 배경색을 투명으로 설정
                                    child: Icon(Icons.my_location_outlined,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
