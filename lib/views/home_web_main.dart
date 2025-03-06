import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/designSize.dart';
import '../utils/donut_chart_painter.dart';
import '../widgets/cutstom_appbar.dart';

class HomeMain2 extends StatefulWidget {
  @override
  _HomeMainState2 createState() => _HomeMainState2();
}

class _HomeMainState2 extends State<HomeMain2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  buildAppBar(),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                        height: 36.h,
                        padding:  EdgeInsets.only(right: 16, left: 16),
                        child: Center(
                          child: Container(
                            width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
                            height: 36.h,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                  },
                                  child: Container(
                                    width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
                                    height: 36.h,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 12, top: 8, bottom: 8),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF3D3D3D),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: ResponsiveUtils.getResponsiveWidth(20, 360, constraints),
                                          height: 20.h,
                                          child: Icon(
                                            Icons.search, // 검색 아이콘 추가
                                            color: Color(0xFF888888), // 아이콘 색상
                                            size: 20.sp, // 아이콘 크기
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Container(
                                          width: ResponsiveUtils.getResponsiveWidth(276, 360, constraints),
                                          height: 20.h,
                                          child: Text(
                                            '매장, 위치 검색',
                                            style: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 14.sp,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              height: 1.40.h,
                                              letterSpacing: -0.35,
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
                        ),
                      );
                    },
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
