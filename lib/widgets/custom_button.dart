import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/FavoriteService.dart';
import '../utils/RouteFinderPage.dart';
import '../utils/designSize.dart';

///로그인
//로그인 버튼
class LoginButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const LoginButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = ResponsiveUtils.getResponsiveWidth(328, 360, constraints);

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12),
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: buttonWidth,
                height: 44.h,
                decoration: ShapeDecoration(
                  color: Color(0xFF05FFF7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.40.h,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

///회원가입
Widget emailInputLabel(String text) {
  return Container(
    width: 360.w,
    height: 20.h,
    padding: EdgeInsets.only(left: 16.w, right: 16.h),
    child: Container(
      width: 328.w,
      height: 20.h,
      child: Text(
        text, // 전달받은 텍스트 사용
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.40.h,
          letterSpacing: -0.35,
        ),
      ),
    ),
  );
}
// 버튼 선택 위젯 (성별, 카테고리 공용)


Widget buildSelectionButtons(
    List<String> labels, int selectedIndex, Function(int) onPressed, BoxConstraints constraints) {
  return Container(
    width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
    height: 48.h,
    padding: EdgeInsets.only(left: 16.w, right: 16.w), // 최상위 패딩 유지
    child: Container(
      width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양옆으로 배치
        children: List.generate(labels.length, (index) {
          return InkWell(
            onTap: () => onPressed(index),
            child: Container(
              width: ResponsiveUtils.getResponsiveWidth(146, 360, constraints),
              height: 48.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: selectedIndex == index ? Color(0xFF05FFF7) : Color(0xFF888888),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: selectedIndex == index ? Color(0xFF05FFF7) : Color(0xFF888888),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

///마이페이지
//마이 페이지 버튼
Widget customButton(String title, VoidCallback onPressed) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 48.h,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(312, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.only(left: 16, top: 14, bottom: 14),
                child: Text(
                  title,
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
              Container(
                width: ResponsiveUtils.getResponsiveWidth(48, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget customPushButton(String title, VoidCallback onPressed, {required bool toggleValue, required ValueChanged<bool> onToggleChanged}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 48.h,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(312, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Text(
                  title,
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
              Container(
                width: ResponsiveUtils.getResponsiveWidth(48, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.all(12), // Switch 크기에 맞게 패딩 조정
                child: Switch(
                  value: toggleValue,
                  onChanged: onToggleChanged,
                  activeColor: Color(0xFF43FFE8),
                  inactiveThumbColor: Color(0xFF454545),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///네이버지도
// 네이버지도 새로고침 버튼
class RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const RefreshButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 141.w,
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: ShapeDecoration(
              color: Color(0xB2242424),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Center(
                    child: Icon(
                      Icons.refresh,
                      color: Color(0xFF05FFF7),
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                SizedBox(
                  width: 89.w,
                  height: 20.h,
                  child: Text(
                    '현 지도에서 검색',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.40.h,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.h,
                          child: FavoriteButton(storeId: id),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigateToDestination(latitude, longitude, address);
                          },
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            child: Icon(
                              Icons.subdirectory_arrow_right_rounded,
                              color: Colors.grey,
                              size: 20.sp,
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
