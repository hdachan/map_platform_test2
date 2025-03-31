import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/modir.dart';
import '../utils/navermap_move.dart';
import '../viewmodels/data_viewmodel.dart';
import '../utils/marker_helper.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/map_viewmodel.dart';
import '../widgets/custom_bottomSheet.dart';
import '../widgets/custom_button.dart';
import '../widgets/naver_bottom.dart';
import '../widgets/naver_widgets.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  NaverMapController? _mapController; // 네이버지도 컨트롤러

  bool _showRefreshButton = false;

  String? _selectedMarkerTitle;

  double _sheetExtent = 0.2;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  String? currentGender;
  late DataViewModel dataProvider; // 데이터 제공자
  List<Modir> filteredData = []; // 필터링된 데이터

  // Supabase 클라이언트 (이미 초기화되어 있다고 가정)
  final supabase = Supabase.instance.client;
  final Map<int, Future<List<String>>> _imageFutures =
      {}; // modir.id별 Future 캐싱


  Map<String, String?> filters = {
    // 다중 필터 맵
    "gender": null,
    "style": null,
    "brand": null,
    "store": null,
  };

  @override
  void initState() {
    super.initState();
    dataProvider = DataViewModel();
    filteredData = dataProvider.dataList; // 초기 데이터 설정
    // 초기 데이터 로드 시 이미지 Future 미리 캐싱 (선택적)
    for (var modir in dataProvider.dataList) {
      _imageFutures[modir.id] = fetchImagesForModir(modir.id);
    }
  }

  void applyFilters() {
    setState(() {
      filteredData = dataProvider.dataList.where((modir) {
        return filters.entries.every((entry) {
          final key = entry.key;
          final value = entry.value;
          if (value == null) return true; // 필터 없으면 통과
          switch (key) {
            case "gender":
              return modir.clothesgender == value;
            case "type": // type 필터 추가
              return modir.type == value;
            case "brand":
              return true; // 아직 구현 안 됨
            case "store":
              return true; // 아직 구현 안 됨
            default:
              return true; // 알 수 없는 키는 통과
          }
        });
      }).toList();
    });
  }

  // 검색 버튼 클릭 시 데이터와 마커 업데이트
  void _onSearchPressed(DataViewModel dataProvider) async {
    final bounds = await _mapController?.getContentBounds();
    if (bounds != null) {
      print(
          'Search triggered, bounds: SW(${bounds.southWest.latitude}, ${bounds.southWest.longitude}), NE(${bounds.northEast.latitude}, ${bounds.northEast.longitude})');

      // 필터가 적용된 경우 필터링된 데이터 불러오기
      if (filters["gender"] != null || filters["type"] != null) {
        await dataProvider.fetchFilteredDataInBounds(
            bounds, filters["gender"], filters["type"]);
      } else {
        // 필터가 없으면 기존 방식으로 전체 데이터 불러오기
        await dataProvider.fetchDataInBounds(bounds);
      }

      _updateMarkers(dataProvider);

      setState(() {
        _showRefreshButton = false; // 검색 후 버튼 숨김
      });
    } else {
      print('Bounds is null on search');
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
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
          modir.address,
          modir.roadAddress,
          modir.type,
          modir.title,
          modir.latitude,
          modir.longitude,
          modir.id,
          modir.trial,
          onClosed: () {
            setState(() {
              _selectedMarkerTitle = null; // 선택 해제
            });
            Future.microtask(() => _updateMarkers(dataProvider)); // 마커 업데이트
          },
        );
      },
      () {
        showCenteredSnackbar(
            context, "현재 지도에는 조건에 맞는 매장이 없어요\n지도 범위를 다시 설정해주세요");
      },
    );
  }

  bool _snackbarShown = false; // ✅ 스낵바 상태 추가

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
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return searchBar(context, constraints);
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
                                Provider.of<MapProvider>(context, listen: false)
                                    .setMapController(controller);
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
                              onCameraChange: (position, reason) async {
                                if (_mapController == null) return;

                                final cameraPosition =
                                    await _mapController!.getCameraPosition();
                                final shouldShowButton =
                                    cameraPosition.zoom >= 13;

                                if (_showRefreshButton != shouldShowButton) {
                                  setState(() {
                                    _showRefreshButton = shouldShowButton;
                                  });
                                }
                              },
                              onCameraIdle: () async {
                                if (_mapController == null) return;

                                final cameraPosition =
                                    await _mapController!.getCameraPosition();
                                print('📍 현재 줌 레벨: ${cameraPosition.zoom}');

                                final shouldShowButton =
                                    cameraPosition.zoom >= 10;

                                if (_showRefreshButton != shouldShowButton) {
                                  setState(() {
                                    _showRefreshButton = shouldShowButton;
                                  });
                                }

                                // ✅ 줌이 10 이상으로 올라가면 _snackbarShown을 즉시 초기화
                                if (shouldShowButton) {
                                  _snackbarShown = false; // 🔥 즉시 반영
                                } else if (!_snackbarShown) {
                                  // ✅ 줌이 10 미만이고 스낵바가 안 떴으면 띄우기
                                  showCenteredSnackbar(
                                      context, "지도를 가까이 가주세요!");
                                  _snackbarShown = true;
                                }

                                print('🔵 버튼 표시 여부: $_showRefreshButton');
                              },
                              options: const NaverMapViewOptions(
                                initialCameraPosition: NCameraPosition(
                                  target: NLatLng(36.1234229, 128.1146402),
                                  zoom: 10,
                                ),
                                logoAlign: NLogoAlign.rightTop,
                                logoMargin: EdgeInsets.only(top: 16, right: 16),
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
                            BottomSheetWidget(
                              sheetController: _sheetController,
                              filters: filters,
                              imageFutures: _imageFutures,
                              onSheetExtentChanged: (extent) {
                                setState(() {
                                  _sheetExtent = extent;
                                });
                              },
                              onUpdateMarkers: _updateMarkers,
                              onFilterChanged: () {
                                setState(() {}); // 필터 변경 시 UI 갱신
                              },
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
                                      backgroundColor: Colors.white,
                                      // 버튼 배경색
                                      foregroundColor: Colors.black,
                                      // 텍스트 및 아이콘 색상
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 8.h),
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


                            CurrentLocationButton(
                              buttonTop: buttonTop,
                              onTap: () => moveToCurrentLocation(_mapController),
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
