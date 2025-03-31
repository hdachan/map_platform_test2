import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../utils/RouteFinderPage.dart';
import '../viewmodels/map_viewmodel.dart';
import 'custom_button.dart';



// 네이버 지도 마커 클릭시 바텀시트 버튼
void showMarkerBottomSheet(
    BuildContext context,
    String address,
    String roadAddress,
    String type,
    String title,
    double latitude,
    double longitude,
    int id,
    String trial, {
      VoidCallback? onClosed, // 닫힘 콜백 추가
    }) {
  print("showMarkerBottomSheet opened with title: $title");

  bool isExpanded = false; // 화살표 클릭 상태

  showBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: 360.w,
        height: 192.h,
        child: Column(
          children: [
            // 제목 영역
            Container(
              width: 360.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.w),
                  topRight: Radius.circular(25.w),
                ),
              ),
              padding: EdgeInsets.only(left: 16, right: 16, top: 12),
              child: Center(
                child: Container(
                  width: 48.w,
                  height: 4.h,
                  color: Colors.white,
                ),
              ),
            ),
            // 내용 영역
            Container(
              width: 360.w,
              height: 172.h,
              color: Color(0xFF1A1A1A),
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
                            children: [
                              Container(
                                width: 212.w,
                                height: 20.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20.h,
                                      child: Text(
                                        '$title',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          height: 1.40,
                                          letterSpacing: -0.35,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        '$type',
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
                              SizedBox(height: 8.h),
                              Container(
                                width: 212.w,
                                height: 16.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '영업',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.30,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '·',
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
                                    SizedBox(width: 2.w),
                                    Text(
                                      '21:30에 영업 종료',
                                      style: TextStyle(
                                        color: Color(0xFFE7E7E7),
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
                              SizedBox(height: 8.h),
                              Container(
                                width: 212.w,
                                height: 16.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '조회',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.30,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '·',
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
                                    SizedBox(width: 2.w),
                                    Text(
                                      '1920명',
                                      style: TextStyle(
                                        color: Color(0xFFE7E7E7),
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.30,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '|',
                                      style: TextStyle(
                                        color: Color(0xFF242424),
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.30,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '댄디 53%',
                                      style: TextStyle(
                                        color: Color(0xFF05FFF7),
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
                              SizedBox(height: 8.h),
                              Container(
                                width: 212.w,
                                height: 16.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '주소',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.30,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '·',
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
                                    SizedBox(width: 2.w),
                                    Text(
                                      '$trial',
                                      style: TextStyle(
                                        color: Color(0xFFE7E7E7),
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.30,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierColor: Colors.transparent,
                                          builder: (context) {
                                            return Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                width: 328.w,
                                                height: 60.h,
                                                padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFF242424),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 296.w,
                                                      height: 18.h,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 34.w,
                                                            height: 18.h,
                                                            padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                            decoration: ShapeDecoration(
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(width: 1, color: Color(0xFF888888)),
                                                                borderRadius: BorderRadius.circular(2),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              '도로명',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Color(0xFF888888),
                                                                fontSize: 10.sp,
                                                                fontFamily: 'Pretendard',
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.40,
                                                                letterSpacing: -0.25,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 6.w),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '$roadAddress',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12,
                                                                  fontFamily: 'Pretendard',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 1.30,
                                                                  letterSpacing: -0.30,
                                                                ),
                                                              ),
                                                              SizedBox(width: 4.w),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Clipboard.setData(ClipboardData(text: roadAddress));
                                                                },
                                                                child: Icon(
                                                                  Icons.copy,
                                                                  color: Colors.white,
                                                                  size: 14.sp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Container(
                                                      width: 296.w,
                                                      height: 18.h,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 34.w,
                                                            height: 18.h,
                                                            padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                                            decoration: ShapeDecoration(
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(width: 1, color: Color(0xFF888888)),
                                                                borderRadius: BorderRadius.circular(2),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              '지번',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Color(0xFF888888),
                                                                fontSize: 10.sp,
                                                                fontFamily: 'Pretendard',
                                                                fontWeight: FontWeight.w500,
                                                                height: 1.40,
                                                                letterSpacing: -0.25,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 6.w),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '$address',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12,
                                                                  fontFamily: 'Pretendard',
                                                                  fontWeight: FontWeight.w500,
                                                                  height: 1.30,
                                                                  letterSpacing: -0.30,
                                                                ),
                                                              ),
                                                              SizedBox(width: 4.w),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Clipboard.setData(ClipboardData(text: address));
                                                                },
                                                                child: Icon(
                                                                  Icons.copy,
                                                                  color: Colors.white,
                                                                  size: 14.sp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
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
                          ),
                          child: FutureBuilder<List<String>>(
                            future: fetchImagesForModir(id), // modir.id로 이미지 리스트 가져오기
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                return Container(
                                  color: Colors.grey,
                                  child: Center(child: Icon(Icons.error, color: Colors.white)),
                                );
                              } else {
                                final imageUrl = snapshot.data!.first; // 첫 번째 이미지 URL
                                return CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey,
                                    child: Center(child: Icon(Icons.error, color: Colors.white)),
                                  ),
                                );
                              }
                            },
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
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.h,
                          child: FavoriteButton(storeId: id),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigateToDestination(
                              latitude,
                              longitude,
                              title,
                              address: address, // named 파라미터로 전달, address 변수가 없으면 null로 처리
                            );
                          },
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            child: Transform.rotate(
                              angle: 0.785, // 약 45도 반시계 방향 회전 (오른쪽에서 상단으로 꺾인 느낌)
                              child: Icon(
                                Icons.navigation , // 꺾인 화살표 아이콘
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 36.w,
                          height: 36.h,
                          child: Icon(
                            Icons.ios_share_outlined,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              builder: (context) {
                                return Stack(
                                  children: [
                                    Positioned(
                                      bottom: 50,
                                      right: 16,
                                      child: Container(
                                        width: 133.w,
                                        height: 88.h,
                                        padding: EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment(0.00, 0.00),
                                            end: Alignment(1.00, 1.00),
                                            colors: [
                                              Color(0xFF242424).withOpacity(0.9),
                                              Color(0xFF242424).withOpacity(0.4)
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Color(0x26000000),
                                              blurRadius: 20,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 101.w,
                                                  height: 20.h,
                                                  child: Text(
                                                    '신고하기',
                                                    style: TextStyle(
                                                      color: Color(0xFFE7E7E7),
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.40,
                                                      letterSpacing: -0.35,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16.h),
                                                Container(
                                                  width: 101.w,
                                                  height: 20.h,
                                                  child: Text(
                                                    '정보 수정 제안하기',
                                                    style: TextStyle(
                                                      color: Color(0xFFE7E7E7),
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
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.more_vert_outlined,
                              color: Colors.grey,
                              size: 20.sp,
                            ),
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
      );
    },
  ).closed.whenComplete(() {
    print("showMarkerBottomSheet closed");
    if (onClosed != null) onClosed(); // 닫힘 시 콜백 호출
  });
}

//지역선택 바텀시트
class FilterBottomSheet {
  static void show(BuildContext context) {
    String? selectedLocation; // 선택된 지역 저장
    Map<String, NLatLng> locationCoordinates = {
      '압구정': NLatLng(37.5271, 127.0286),
      '홍대': NLatLng(37.5561, 126.9236),
      '동묘': NLatLng(37.5722, 127.0168),
      '망원': NLatLng(37.5569, 126.9104),
      '합정': NLatLng(37.5495, 126.9137),
      '이태원': NLatLng(37.5345, 126.9946),
      '성수': NLatLng(37.5444, 127.0563),
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF1A1A1A),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 360.w,
              height: 500.h,
              child: Column(
                children: [
                  Container(
                    width: 360.w,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    child: Text(
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
                    padding: EdgeInsets.only(top: 12, bottom: 12),
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 360.w,
                    height: 348.h,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 120.w,
                              height: 44.h,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Center(
                                child: Text(
                                  '서울',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.40,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SelectableList(
                              onSelected: (value) {
                                setState(() {
                                  selectedLocation = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360.w,
                    height: 68.h,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF888888),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '닫기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            if (selectedLocation != null && locationCoordinates.containsKey(selectedLocation)) {
                              final mapProvider = context.read<MapProvider>();
                              final coords = locationCoordinates[selectedLocation]!;

                              mapProvider.moveToLocation(coords.latitude, coords.longitude);
                              print("최종 선택된 위치: $selectedLocation -> ${coords.latitude}, ${coords.longitude}");
                            } else {
                              print("선택된 위치가 없습니다.");
                            }

                            Navigator.pop(context, selectedLocation);
                          },
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF05FFF7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '적용',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// 매장 바텀시트
class StoreTypeBottomSheet {
  static Future<String?> show(BuildContext context) async {
    String? selectedType;

    return await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget typeButton(String type, {double? width}) {
              bool isSelected = selectedType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedType = type;
                  });
                },
                child: Container(
                  width: width ?? 156.w,
                  height: 36.h,
                  decoration: ShapeDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF888888)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Color(0xFF888888),
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.40,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
              );
            }

            return Container(
              width: 360.w,
              height: 500.h,
              child: Column(
                children: [
                  Container(
                    width: 360.w,
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Text(
                      '매장 유형',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      typeButton('편집샵'), // "온라인" → "편집샵"
                      SizedBox(width: 16.w),
                      typeButton('구제'),   // "오프라인" → "구제"
                    ],
                  ),
                  // "플래그십"을 남길지 삭제할지 모호해서 주석 처리. 필요하면 아래 줄 주석 해제
                  // SizedBox(height: 12.h),
                  // typeButton('플래그십', width: 328.w),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context, null), // 필터 해제
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF888888),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text('닫기', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () => Navigator.pop(context, selectedType),
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF05FFF7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text('적용', style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// 남여 바텀시트
class GenderBottomSheet {
  static Future<String?> show(BuildContext context) async {
    String? selectedGender;

    return await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget genderButton(String gender, {double? width}) {
              bool isSelected = selectedGender == gender;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = gender;
                  });
                },
                child: Container(
                  width: width ?? 156.w,
                  height: 36.h,
                  decoration: ShapeDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF888888)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    gender,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Color(0xFF888888),
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.40,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
              );
            }

            return Container(
              width: 360.w,
              height: 500.h,
              child: Column(
                children: [
                  Container(
                    width: 360.w,
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Text(
                      '성별',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genderButton('남자'),
                      SizedBox(width: 16.w),
                      genderButton('여자'),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  genderButton('남여공용', width: 328.w),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context, null), // 필터 해제
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF888888),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text('닫기', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () => Navigator.pop(context, selectedGender),
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF05FFF7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text('적용', style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// 스타일 바텀시트
class BrandBottomSheet {
  static void show(BuildContext context) {
    String? selectedLocation; // 선택된 지역 저장

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF1A1A1A),
      builder: (BuildContext context) {
        return StatefulBuilder( // 상태 변경을 위해 StatefulBuilder 사용
          builder: (context, setState) {
            return Container(
              width: 360.w,
              height: 500.h,
              child: Column(
                children: [
                  Container(
                    width: 360.w,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    child: Text(
                      '스타일',
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
                      height: 388.h,
                      padding: EdgeInsets.only(left: 16,right: 16,bottom: 8,top: 8),
                      child: Container(
                        width: 328.w,
                        height: 36.h,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 156.w,
                                  height: 36.h,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFF888888)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Container(
                                    width: 124.w,
                                    height: 20.h,
                                    padding: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                                    child: Text(
                                      '아메카지',
                                      textAlign: TextAlign.center,
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
                                ),
                                SizedBox(width: 16.w),
                                Container(
                                  width: 156.w,
                                  height: 36.h,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFF888888)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Container(
                                    width: 124.w,
                                    height: 20.h,
                                    padding: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                                    child: Text(
                                      '캐주얼',
                                      textAlign: TextAlign.center,
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  Container(
                    width: 360.w,
                    height: 68.h,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF888888),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '닫기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            print("최종 선택된 위치: $selectedLocation");
                            Navigator.pop(context, selectedLocation);
                          },
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF05FFF7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '적용',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// 브랜드 바텀시트
class bbbbbBottomSheet {
  static void show(BuildContext context) {
    String? selectedLocation; // 선택된 지역 저장

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF1A1A1A),
      builder: (BuildContext context) {
        return StatefulBuilder( // 상태 변경을 위해 StatefulBuilder 사용
          builder: (context, setState) {
            return Container(
              width: 360.w,
              height: 500.h,
              child: Column(
                children: [
                  Container(
                    width: 360.w,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    child: Text(
                      '브랜드',
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
                    height: 52.h,
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                    child: Container(
                      width: 328.w,
                      height: 36.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFF3D3D3D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '찾는 브랜드 검색를 검색해주세요', // 기존 텍스트를 힌트로 사용
                          hintStyle: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.40,
                            letterSpacing: -0.35,
                          ),
                          border: InputBorder.none, // 테두리 제거 (기본 스타일 유지)
                        ),
                        style: TextStyle(
                          color: Colors.black, // 입력 텍스트 색상 (필요에 따라 변경)
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 1.40,
                          letterSpacing: -0.35,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 360.w,
                    height: 36.h,
                    padding: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                    child:         Text(
                      '전체',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                        letterSpacing: -0.35,
                      ),
                    ),
                  ),
                  Container(
                    width: 360.w,
                    height: 56.h,
                    padding: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 156.w,
                          height: 40.h,
                          padding: EdgeInsets.only(top: 4,bottom: 4),
                          child:Row(
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.h,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF242424),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                width: 128.w,
                                height: 32.h,
                                child: Text(
                                  '안데르센 안데르센\nANDERSEN-ANDERSEN',
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 10.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.40,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Container(
                          width: 156.w,
                          height: 40.h,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360.w,
                    height: 68.h,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF888888),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '닫기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            print("최종 선택된 위치: $selectedLocation");
                            Navigator.pop(context, selectedLocation);
                          },
                          child: Container(
                            width: 156.w,
                            height: 36.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFF05FFF7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '적용',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}




// 위치별로 이동하기
class SelectableList extends StatefulWidget {
  final Function(String) onSelected; // 선택한 값을 전달할 콜백

  SelectableList({required this.onSelected});

  @override
  _SelectableListState createState() => _SelectableListState();
}

class _SelectableListState extends State<SelectableList> {
  String? temporarySelectedText; // 임시 선택된 값

  void _handleSelection(String text) {
    setState(() {
      temporarySelectedText = text;
    });
    widget.onSelected(text); // 선택한 값을 부모 위젯으로 전달
  }

  @override
  Widget build(BuildContext context) {
    List<String> locations = ['압구정', '홍대', '동묘', '망원', '합정', '이태원', '성수'];

    return Column(
      children: locations.map((location) {
        return SelectableContainer(
          text: location,
          isSelected: temporarySelectedText == location,
          onTap: () => _handleSelection(location),
        );
      }).toList(),
    );
  }
}


// 위치별로 이동하기 버튼
class SelectableContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableContainer({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240.w,
        height: 44.h,
        decoration: ShapeDecoration(
          color: isSelected ? Color(0xFF3D3D3D): Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFF242424)),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 1.40,
              letterSpacing: -0.35,
            ),
          ),
        ),
      ),
    );
  }
}



