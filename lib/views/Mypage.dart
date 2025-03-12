import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled114/views/home_mypage_setting.dart';

import '../utils/designSize.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'home_mypage_edit.dart';

class mmmm extends StatefulWidget {
  const mmmm({Key? key}) : super(key: key);

  @override
  mmmm1 createState() => mmmm1();
}

class mmmm1 extends State<mmmm> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // 디자인 사이즈 초기화
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  custom_mypage_AppBar(
                    onNotificationTap: () {
                      print("알림 버튼 클릭됨");
                    },
                    onSettingsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Setting1()), // Mmmm4는 이동할 화면의 위젯입니다.
                      );
                    },
                  ),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileEditScreen()), // Mmmm4는 이동할 화면의 위젯입니다.
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 132.h,
                          padding: EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 16),
                          child: Container( // 여기부분이 중간에 떠야됨
                            width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
                            height: 84.h,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(1.00, -0.08),
                                end: Alignment(-1, 0.08),
                                colors: [Color(0xFF242424), Color(0x4C242424)],
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: const Color(0xFF3D3D3D),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x26000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: ResponsiveUtils.getResponsiveWidth(48, 360, constraints),
                                  height: 48.h,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  width: ResponsiveUtils.getResponsiveWidth(236, 360, constraints),
                                  height: 48.h,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: ResponsiveUtils.getResponsiveWidth(236, 360, constraints),
                                        height: 28.h,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: ResponsiveUtils.getResponsiveWidth(183, 360, constraints),
                                              height: 28.h,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '모디랑님',
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
                                            ),
                                            SizedBox(width: 8),
                                            Container(
                                              width: ResponsiveUtils.getResponsiveWidth(45, 360, constraints),
                                              height: 28.h,
                                              padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1, color: const Color(0xFF05FFF7)),
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                              ),
                                              child:Center(
                                                child: Text(
                                                  '수정',
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
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        width: ResponsiveUtils.getResponsiveWidth(236, 360, constraints),
                                        height: 16.h,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 24.h,
                                              child:  Text(
                                                '남성',
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
                                            SizedBox(width: 4),
                                            Container(
                                              width: ResponsiveUtils.getResponsiveWidth(4, 360, constraints),
                                              height: 20.h,
                                              child: Text(
                                                '·',
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
                                            SizedBox(width: 4),
                                            Container(
                                              height: 20.h,
                                              child:Text(
                                                '177cm',
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
                                            SizedBox(width: 4),
                                            Container(
                                              width: ResponsiveUtils.getResponsiveWidth(4, 360, constraints),
                                              height: 20.h,
                                              child: Text(
                                                '·',
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
                                            SizedBox(width: 4),
                                            Container(
                                              height: 20.h,
                                              child: Center(
                                                child: Text(
                                                  '70kg',
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
                      );
                    },
                  ),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        width: double.infinity,
                        height: 16.h,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '현재 ',
                                style: TextStyle(
                                  color: const Color(0xFFF6F6F6),
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.30,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              TextSpan(
                                text: '스트릿 기반의 비즈니스 캐주얼',
                                style: TextStyle(
                                  color: const Color(0xFF05FFF7),
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.30,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              TextSpan(
                                text: '을 선호해요',
                                style: TextStyle(
                                  color: const Color(0xFFF6F6F6),
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
                      );
                    },
                  ),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                        height: 56.h,
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                        child: Container(
                          width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
                          height: 40.h,
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(1.00, -0.01),
                              end: Alignment(-1, 0.01),
                              colors: [Color(0xFF05FFF7), Color(0xFF03CFDB)],
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: ResponsiveUtils.getResponsiveWidth(272, 360, constraints),
                                height: 16.h,
                                child:  Text(
                                  '내 패션 DNA 조사',
                                  style: TextStyle(
                                    color: Color(0xFF1A1A1A),
                                    fontSize: 12.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.30,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                width: ResponsiveUtils.getResponsiveWidth(16, 360, constraints),
                                height: 16.h,
                                child:  Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16.sp,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // middleText('활동'),
                  // LayoutBuilder(
                  //   builder: (BuildContext context, BoxConstraints constraints) {
                  //     return Container(
                  //       width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                  //       height: 228.h,
                  //       padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
                  //       child: Container(
                  //         width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
                  //         height: 180.h,
                  //         decoration: ShapeDecoration(
                  //           color: const Color(0xFF242424),
                  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               width: ResponsiveUtils.getResponsiveWidth(127, 360, constraints),
                  //               height: 20.h,
                  //               child:  Text(
                  //                 '현재 올린 코디가 없어요',
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                   color: Color(0xFF888888),
                  //                   fontSize: 14.sp,
                  //                   fontFamily: 'Pretendard',
                  //                   fontWeight: FontWeight.w700,
                  //                   height: 1.40,
                  //                   letterSpacing: -0.35,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 8.h),
                  //             Container(
                  //               width: ResponsiveUtils.getResponsiveWidth(170, 360, constraints),
                  //               height: 17.h,
                  //               child: Text(
                  //                 '자신이 생각한 스타일을 공유해보세요',
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                   color: Color(0xFF888888),
                  //                   fontSize: 12.sp,
                  //                   fontFamily: 'Pretendard',
                  //                   fontWeight: FontWeight.w500,
                  //                   height: 1.40,
                  //                   letterSpacing: -0.30,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // LayoutBuilder(
                  //   builder: (BuildContext context, BoxConstraints constraints) {
                  //     return Container(
                  //       width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                  //       height: 60.h,
                  //       padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                  //       child: Container(
                  //         width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
                  //         height: 44.h,
                  //         padding: const EdgeInsets.only(left: 16,right: 16,top: 12,bottom: 12),
                  //         decoration: ShapeDecoration(
                  //           gradient: LinearGradient(
                  //             begin: Alignment(1.00, -0.08),
                  //             end: Alignment(-1, 0.08),
                  //             colors: [Color(0xFF242424), Color(0x4C242424)],
                  //           ),
                  //           shape: RoundedRectangleBorder(
                  //             side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //           shadows: [
                  //             BoxShadow(
                  //               color: Color(0x26000000),
                  //               blurRadius: 20,
                  //               offset: Offset(0, 4),
                  //               spreadRadius: 0,
                  //             )
                  //           ],
                  //         ),
                  //         child:  Text(
                  //           '코디 올리러 가기',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             color: Color(0xFF05FFF7),
                  //             fontSize: 14.sp,
                  //             fontFamily: 'Pretendard',
                  //             fontWeight: FontWeight.w500,
                  //             height: 1.40,
                  //             letterSpacing: -0.35,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  SizedBox(height: 24.h),
                  middleText('기록'),
                  customButton(
                    '최근에 본 매장',
                        () {
                      // 버튼 클릭 시 수행할 작업을 여기에 작성하세요.
                      print('버튼이 클릭되었습니다!');
                    },
                  ),
                  middleText('관심'),
                  customButton(
                    '관심 매장',
                        () {
                    },
                  ),
                  middleText('문의'),
                  customButton(
                    '매장에 문의한 글',
                        () {
                      // 버튼 클릭 시 수행할 작업을 여기에 작성하세요.
                      print('버튼22이 클릭되었습니다!');
                    },
                  ),
                  middleText('센터'),
                  customButton(
                    '공지사항',
                        () {
                      // 버튼 클릭 시 수행할 작업을 여기에 작성하세요.
                      print('버튼22이 클릭되었습니다!');
                    },
                  ),
                  customButton(
                    'FQA',
                        () {
                      // 버튼 클릭 시 수행할 작업을 여기에 작성하세요.
                      print('버튼22이 클릭되었습니다!');
                    },
                  ),
                  customButton(
                    '1:1 문의하기',
                        () {
                      // 버튼 클릭 시 수행할 작업을 여기에 작성하세요.
                      print('버튼22이 클릭되었습니다!');
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