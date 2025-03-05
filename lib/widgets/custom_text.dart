import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/designSize.dart';

// 마이페이지 중간 텍스트
Widget middleText(String text) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 60.h,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
        child: Container(
          width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
          height: 28.h,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.40,
              letterSpacing: -0.50,
            ),
          ),
        ),
      );
    },
  );
}

// 가입하기 텍스트
Widget Signuptext(String title, String subtitle) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints), // 360.w 대신 반응형 너비
        height: 148.h, // 높이는 그대로 유지
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 48, bottom: 42),
        child: Column(
          children: [
            Container(
              width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints), // 328.w 대신 반응형 너비
              height: 28.h, // 높이는 그대로 유지
              child: Text(
                title, // 전달받은 title 사용
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.40,
                  letterSpacing: -0.50,
                ),
              ),
            ),
            SizedBox(height: 8.h), // 간격 그대로 유지
            Container(
              width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints), // 328.w 대신 반응형 너비
              height: 16.h, // 높이는 그대로 유지
              child: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  letterSpacing: -0.30,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

//회원가입_서브텍스트
Widget Subtext(String nickname, BoxConstraints constraints) {
  return Container(
    width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
    height: 20.h,
    padding: EdgeInsets.only(
      left: 16.w,
      right: 16.w,
    ),
    child: Container(
      width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
      height: 20.h,
      child: Text(
        nickname, // 전달받은 닉네임 텍스트 사용
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

