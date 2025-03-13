
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// 디자인 사이즈
void initScreenUtil(BuildContext context) {
  ScreenUtil.init(
      context,designSize: Size(360, 740), // 디자인 기준 사이즈를 360으로 설정
  minTextAdapt: true,
  splitScreenMode: true,
  );
}

/// 반응형 디자인
class ResponsiveUtils {
  // 기준 디자인 너비(360px)와 최대 너비를 기반으로 크기 계산
  static double getResponsiveWidth(
      double designWidth, double designBaseWidth, BoxConstraints constraints) {
    double containerWidth = constraints.maxWidth; // 부모의 최대 너비
    return containerWidth * (designWidth / designBaseWidth);
  }
}