import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/cutstom_appbar.dart';

class WithdrawalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                CustomAppBar(title: '탈퇴하기', context: context),
                Container(
                  width: 360.w,
                  height: 130.h,
                  padding: EdgeInsets.only(left: 16,right: 16,top: 24,bottom: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 328.w,
                        height: 50.h,
                        child: Text(
                          '모디랑 서비스를 이용해주신 지날 날들을 \n진심으로 감사하게 생각합니다.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.40,
                            letterSpacing: -0.45,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 328.w,
                        height: 40.h,
                        child: Text(
                          '고객님이 느끼신 불편한 점들을 저희에게 알려주신다면 \n더욱 도움이 되는 서비스를 제공할 수 있도록 하겠습니다.',
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
                Container(
                  width: 360.w,
                  height: 212.h,
                  padding: EdgeInsets.only(top: 16,bottom: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 360.w,
                        height: 36.h,
                        padding: EdgeInsets.only(right: 16,left: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3D3D3D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center( // 아이콘을 중앙에 배치하기 위해 Center 위젯 사용
                                child: Icon(
                                  Icons.check, // 체크 아이콘
                                  color: Colors.white, // 아이콘 색상
                                  size: 14.sp, // 아이콘 크기
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),
                            Container(
                              width: 300.w,
                              height: 20.h,
                              child: Text(
                                '잘 안사용하게 되는 것 같아요',
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
                      Container(
                        width: 360.w,
                        height: 36.h,
                        padding: EdgeInsets.only(right: 16,left: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3D3D3D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center( // 아이콘을 중앙에 배치하기 위해 Center 위젯 사용
                                child: Icon(
                                  Icons.check, // 체크 아이콘
                                  color: Colors.white, // 아이콘 색상
                                  size: 14.sp, // 아이콘 크기
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),
                            Container(
                              width: 300.w,
                              height: 20.h,
                              child: Text(
                                '서비스 지연이 너무 심해요',
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
                      Container(
                        width: 360.w,
                        height: 36.h,
                        padding: EdgeInsets.only(right: 16,left: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3D3D3D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center( // 아이콘을 중앙에 배치하기 위해 Center 위젯 사용
                                child: Icon(
                                  Icons.check, // 체크 아이콘
                                  color: Colors.white, // 아이콘 색상
                                  size: 14.sp, // 아이콘 크기
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),
                            Container(
                              width: 300.w,
                              height: 20.h,
                              child: Text(
                                '매장 찾는게 불편해요',
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
                      Container(
                        width: 360.w,
                        height: 36.h,
                        padding: EdgeInsets.only(right: 16,left: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3D3D3D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center( // 아이콘을 중앙에 배치하기 위해 Center 위젯 사용
                                child: Icon(
                                  Icons.check, // 체크 아이콘
                                  color: Colors.white, // 아이콘 색상
                                  size: 14.sp, // 아이콘 크기
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),
                            Container(
                              width: 300.w,
                              height: 20.h,
                              child: Text(
                                '필요없는 내용이 너무 많아요',
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
                      Container(
                        width: 360.w,
                        height: 36.h,
                        padding: EdgeInsets.only(right: 16,left: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3D3D3D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Center( // 아이콘을 중앙에 배치하기 위해 Center 위젯 사용
                                child: Icon(
                                  Icons.check, // 체크 아이콘
                                  color: Colors.white, // 아이콘 색상
                                  size: 14.sp, // 아이콘 크기
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),
                            Container(
                              width: 300.w,
                              height: 20.h,
                              child: Text(
                                '기타',
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
                    ],
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
