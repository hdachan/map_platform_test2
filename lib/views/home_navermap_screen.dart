import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/modir.dart';
import '../utils/animation.dart';
import '../utils/designSize.dart';
import '../viewmodels/data_viewmodel.dart';
import '../utils/marker_helper.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/map_viewmodel.dart';
import '../widgets/custom_bottomSheet.dart';
import '../widgets/custom_button.dart';
import 'FavoriteStoresScreen.dart';
import 'home_navermap_search_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  NaverMapController? _mapController;
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

// 이미지 가져오는 함수
  Future<List<String>> fetchImagesForModir(int modirId) async {
    try {
      final response = await supabase
          .from('modir_images')
          .select('image_url')
          .eq('modir_id', modirId);
      return response.isNotEmpty
          ? response.map((row) => row['image_url'] as String).toList()
          : [];
    } catch (e) {
      print('Error fetching images for modir $modirId: $e');
      return [];
    }
  }



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
                                  Navigator.push(
                                    context,
                                    createSlideUpRoute(search_screen()),
                                  );
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
                                  Navigator.push(
                                    context,
                                    createFadeRoute(FavoriteStoresScreen()),
                                  );
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
                                      Icons.storefront_outlined ,
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
                            NotificationListener<
                                DraggableScrollableNotification>(
                              onNotification: (notification) {
                                setState(() {
                                  _sheetExtent = notification.extent;
                                });
                                return true;
                              },
                              child: DraggableScrollableSheet(
                                controller: _sheetController,
                                initialChildSize: 0.2,
                                minChildSize: 0.2,
                                maxChildSize: 1.0,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
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
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 4,
                                                      bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 231.w,
                                                        height: 20.h,
                                                        child: Text(
                                                          '나에게 맞는 매장을 찾아봐요!',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.sp,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.10.h,
                                                            letterSpacing:
                                                                -0.45,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      InkWell(
                                                        onTap: () {
                                                          FilterBottomSheet
                                                              .show(context);
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: Container(
                                                          width: 89.w,
                                                          height: 32.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 8),
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFF888888)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                size: 16.sp,
                                                                color: Color(
                                                                    0xFF05FFF7),
                                                              ),
                                                              SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                '지역선택',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  height: 1.30,
                                                                  letterSpacing:
                                                                      -0.30,
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
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 12,
                                                      bottom: 12),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          BrandBottomSheet.show(
                                                              context);
                                                        },
                                                        child: Container(
                                                          width: 77.w,
                                                          height: 32.h,
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFF3D3D3D)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16,
                                                                  right: 12,
                                                                  top: 8,
                                                                  bottom: 8),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 31.w,
                                                                height: 16.h,
                                                                child: Text(
                                                                  '스타일',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height:
                                                                        1.30,
                                                                    letterSpacing:
                                                                        -0.30,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2.w),
                                                              Container(
                                                                width: 16.w,
                                                                height: 16.h,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                    size: 16.sp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          final selectedGender =
                                                              await GenderBottomSheet
                                                                  .show(
                                                                      context);
                                                          setState(() {
                                                            filters["gender"] =
                                                                selectedGender;
                                                            final dataProvider =
                                                                context.read<
                                                                    DataViewModel>();
                                                            if (selectedGender !=
                                                                    null ||
                                                                filters["type"] !=
                                                                    null) {
                                                              dataProvider
                                                                  .fetchFilteredDataInBounds(
                                                                dataProvider
                                                                    .currentBounds!,
                                                                filters[
                                                                    "gender"],
                                                                filters["type"],
                                                              )
                                                                  .then((_) {
                                                                _updateMarkers(
                                                                    dataProvider);
                                                              });
                                                            } else {
                                                              dataProvider
                                                                  .fetchDataInBounds(
                                                                dataProvider
                                                                    .currentBounds!,
                                                              )
                                                                  .then((_) {
                                                                _updateMarkers(
                                                                    dataProvider);
                                                              });
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 67.w,
                                                          height: 32.h,
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFF3D3D3D)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16,
                                                                  right: 12,
                                                                  top: 8,
                                                                  bottom: 8),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 21.w,
                                                                height: 16.h,
                                                                child: Text(
                                                                  filters["gender"] ??
                                                                      '성별',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height:
                                                                        1.30,
                                                                    letterSpacing:
                                                                        -0.30,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2.w),
                                                              Container(
                                                                width: 16.w,
                                                                height: 16.h,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                    size: 16.sp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          final selectedType =
                                                              await StoreTypeBottomSheet
                                                                  .show(
                                                                      context);
                                                          setState(() {
                                                            filters["type"] =
                                                                selectedType;
                                                            final dataProvider =
                                                                context.read<
                                                                    DataViewModel>();
                                                            if (selectedType !=
                                                                    null ||
                                                                filters["gender"] !=
                                                                    null) {
                                                              dataProvider
                                                                  .fetchFilteredDataInBounds(
                                                                dataProvider
                                                                    .currentBounds!,
                                                                filters[
                                                                    "gender"],
                                                                filters["type"],
                                                              )
                                                                  .then((_) {
                                                                _updateMarkers(
                                                                    dataProvider);
                                                              });
                                                            } else {
                                                              dataProvider
                                                                  .fetchDataInBounds(
                                                                dataProvider
                                                                    .currentBounds!,
                                                              )
                                                                  .then((_) {
                                                                _updateMarkers(
                                                                    dataProvider);
                                                              });
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 67.w,
                                                          height: 32.h,
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFF3D3D3D)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16,
                                                                  right: 12,
                                                                  top: 8,
                                                                  bottom: 8),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 21.w,
                                                                height: 16.h,
                                                                child: Text(
                                                                  filters["type"] ??
                                                                      '매장',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height:
                                                                        1.30,
                                                                    letterSpacing:
                                                                        -0.30,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2.w),
                                                              Container(
                                                                width: 16.w,
                                                                height: 16.h,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_outlined,
                                                                    size: 16.sp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
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
                                                  height: 32.h,
                                                  color: Color(0xFF1A1A1A),
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 8,
                                                      bottom: 8),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '총 ${dataProvider.dataList.length} 개의 매장',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              'Pretendard',
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                              final modir =
                                                  dataProvider.dataList[index];
                                              print(
                                                  'Building SliverList item $index: ${modir.title}');
                                              if (!_imageFutures
                                                  .containsKey(modir.id)) {
                                                _imageFutures[modir.id] =
                                                    fetchImagesForModir(
                                                        modir.id);
                                              }
                                              return GestureDetector(
                                                onTap: () {
                                                  _sheetController.animateTo(
                                                    0.2,
                                                    duration: Duration(
                                                        milliseconds: 300),
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
                                                  );
                                                },
                                                child: Container(
                                                  width: 360.w,
                                                  height: 226.h,
                                                  decoration: ShapeDecoration(
                                                    color: Color(0xFF1A1A1A),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Color(
                                                              0xFF242424)),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 16, bottom: 16),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 360.w,
                                                        height: 18.h,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16,
                                                                right: 16),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 18.h,
                                                              decoration:
                                                                  ShapeDecoration(
                                                                color: Color(
                                                                    0xFFF6F6F6),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                ),
                                                              ),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 4,
                                                                      right: 4,
                                                                      bottom: 2,
                                                                      top: 2),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          2.w),
                                                                  Container(
                                                                    height:
                                                                        14.h,
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .person_outline,
                                                                          size:
                                                                              12.sp,
                                                                          color:
                                                                              Color(0xFF0B5C1F),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                4.w),
                                                                        Text(
                                                                          modir
                                                                              .clothesgender,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFF0B5C1F),
                                                                            fontSize:
                                                                                10.sp,
                                                                            fontFamily:
                                                                                'Pretendard',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.40,
                                                                            letterSpacing:
                                                                                -0.25,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Container(
                                                        width: 360.w,
                                                        height: 20.h,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16,
                                                                right: 16),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              height: 20.h,
                                                              child: Text(
                                                                modir.title,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.40,
                                                                  letterSpacing:
                                                                      -0.35,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 4.w),
                                                            Container(
                                                              width: 150.h,
                                                              height: 16.h,
                                                              child: Text(
                                                                modir.type,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF888888),
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.30,
                                                                  letterSpacing:
                                                                      -0.30,
                                                                ),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Container(
                                                              width: 20.h,
                                                              height: 20.h,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .favorite_outline,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Container(
                                                        width: 360.w,
                                                        height: 28.h,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16,
                                                                right: 16),
                                                        child: Text(
                                                          modir.description,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFE7E7E7),
                                                            fontSize: 10.sp,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.40,
                                                            letterSpacing:
                                                                -0.25,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Container(
                                                        width: 360.w,
                                                        height: 104.h,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16,
                                                                right: 16),
                                                        child: FutureBuilder<
                                                            List<String>>(
                                                          future: _imageFutures[
                                                              modir.id],
                                                          // 캐싱된 Future 사용
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot.connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children: List
                                                                      .generate(
                                                                          4,
                                                                          (_) =>
                                                                              Container(
                                                                                width: 104.w,
                                                                                height: 104.h,
                                                                                margin: EdgeInsets.only(right: 8.w),
                                                                                color: Colors.grey[300],
                                                                                child: Center(child: CircularProgressIndicator()),
                                                                              )),
                                                                ),
                                                              );
                                                            } else if (snapshot
                                                                    .hasError ||
                                                                !snapshot
                                                                    .hasData ||
                                                                snapshot.data!
                                                                    .isEmpty) {
                                                              return SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children: List
                                                                      .generate(
                                                                          4,
                                                                          (_) =>
                                                                              Container(
                                                                                width: 104.w,
                                                                                height: 104.h,
                                                                                margin: EdgeInsets.only(right: 8.w),
                                                                                color: Colors.grey,
                                                                                child: Center(child: Icon(Icons.error, color: Colors.white)),
                                                                              )),
                                                                ),
                                                              );
                                                            } else {
                                                              final imageUrls =
                                                                  snapshot
                                                                      .data!;
                                                              return SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children: imageUrls
                                                                          .isNotEmpty
                                                                      ? imageUrls
                                                                          .take(
                                                                              4)
                                                                          .map(
                                                                              (url) {
                                                                          return Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 8.w),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: url,
                                                                              width: 104.w,
                                                                              height: 104.h,
                                                                              fit: BoxFit.cover,
                                                                              placeholder: (context, url) => Container(
                                                                                color: Colors.grey[300],
                                                                                child: Center(child: CircularProgressIndicator()),
                                                                              ),
                                                                              errorWidget: (context, url, error) => Container(
                                                                                color: Colors.grey,
                                                                                child: Center(child: Icon(Icons.error, color: Colors.white)),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }).toList()
                                                                      : List.generate(
                                                                          4,
                                                                          (_) => Container(
                                                                                width: 104.w,
                                                                                height: 104.h,
                                                                                margin: EdgeInsets.only(right: 8.w),
                                                                                color: Colors.grey,
                                                                                child: Center(child: Icon(Icons.image_not_supported, color: Colors.white)),
                                                                              )),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            childCount:
                                                dataProvider.dataList.length,
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
