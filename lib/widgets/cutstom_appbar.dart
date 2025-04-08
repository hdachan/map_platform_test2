import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/designSize.dart';

// 로그인 상단바
Widget CustomloginAppBar({required String title, required BuildContext context}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: double.infinity,
        height: 56.h,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: ResponsiveUtils.getResponsiveWidth(56, 360, constraints),
                height: 56.h,
                child: Center(
                  child: Icon(
                    Icons.chevron_left,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: ResponsiveUtils.getResponsiveWidth(248, 360, constraints),
              height: 56.h,
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽 중앙에 정렬
              child: Text(
                title, // 전달받은 텍스트 사용
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.40.h,
                  letterSpacing: -0.50,
                ),
              ),
            ),
            Container(
              width: ResponsiveUtils.getResponsiveWidth(56, 360, constraints),
              height: 56.h,
              padding:
              EdgeInsets.only(left: 14.h, right: 14.w, top: 20.h, bottom: 20.h),
              child: Container(
                width: ResponsiveUtils.getResponsiveWidth(28, 360, constraints),
                height: 16.h,
                child: SvgPicture.asset(
                  'assets/image/mini_logo.svg', // SVG 파일 경로
                  fit: BoxFit.contain, // 이미지 비율 유지
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// 마이페이지 상단바
Widget custom_mypage_AppBar({
  required VoidCallback onNotificationTap,
  required VoidCallback onSettingsTap,
}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 56.h,
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.getResponsiveWidth(248, 360, constraints),
              height: 56.h,
              padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: ResponsiveUtils.getResponsiveWidth(28, 360, constraints),
                    height: 16.h,
                    child: Image.asset(
                      'assets/image/logo_primary2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                width: ResponsiveUtils.getResponsiveWidth(56, 360, constraints),
                height: 56.h,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 24.sp,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                width: ResponsiveUtils.getResponsiveWidth(56, 360, constraints),
                height: 56.h,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Icon(
                    Icons.settings_outlined,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// 돟의하기 화면 상단바
Widget CustomAppBar({required String title, required BuildContext context}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 56.h,
        color: const Color(0xFF1A1A1A),
        padding: EdgeInsets.only(
          right: ResponsiveUtils.getResponsiveWidth(16, 360, constraints),
        ),
        child: Row(
          children: [
            // 뒤로가기 버튼
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: ResponsiveUtils.getResponsiveWidth(56, 360, constraints),
                height: 56.h,
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.chevron_left,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: ResponsiveUtils.getResponsiveWidth(280, 360, constraints),
              height: 56.h,
              color: Colors.cyan,
              padding: const EdgeInsets.only(top: 14,bottom: 14),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.40,
                  letterSpacing: -0.50,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


//홈화면 상단바
Widget buildAppBar() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 56.h,
        color: Color(0xFF1A1A1A),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.getResponsiveWidth(56, 360, constraints),
              height: 56.h,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: ResponsiveUtils.getResponsiveWidth(100, 360, constraints),
                  height: 20.h,
                  child: SvgPicture.asset(
                    'assets/image/logo_primary.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              width: ResponsiveUtils.getResponsiveWidth(56, 360, constraints),
              height: 56.h,
            ),
          ],
        ),
      );
    },
  );
}


//테스트 필터
Widget buildHeaderBar(BuildContext context, {required String filterText, required String resetText,}) {
  return Container(
    width: 360.w,
    height: 56.h,
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // 뒤로가기 기능
          },
          child: Container(
            width: 56.w,
            height: 56.h,
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.chevron_left,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: 252.w,
          height: 56.h,
          padding: EdgeInsets.only(top: 14, bottom: 14),
          child: Text(
            filterText, // 전달받은 필터 텍스트 사용
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.40.h,
              letterSpacing: -0.50,
            ),
          ),
        ),
        Container(
          width: 36.w,
          height: 56.h,
          padding: EdgeInsets.only(top: 18, bottom: 18),
          child: TextButton(
            onPressed: () {
              print("$resetText 버튼이 눌렸습니다. 선택된 필터 목록이 비워졌습니다.");
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              resetText, // 전달받은 초기화 텍스트 사용
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF05FFF7),
                fontSize: 14.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                height: 1.40.h,
                letterSpacing: -0.35,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}