import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/designSize.dart';
import '../utils/donut_chart_painter.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeMain1 extends StatefulWidget {
  @override
  _HomeMainState1 createState() => _HomeMainState1();
}

class _HomeMainState1 extends State<HomeMain1> {
  int selectedIndex = 0; // 현재 선택된 컨테이너 인덱스

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/image/test01.png',
      'text': 'SUPUL 수풀\n제주도 감성 라이프 스타일',
    },
    {
      'image': 'assets/image/test02.png',
      'text': '나이스웨더\n하나의 라이프 스타일 브랜드',
    },
    {
      'image': 'assets/image/test03.png',
      'text': 'Grass Society\n우아함과 깔끔함의 정석',
    },
  ];
  Widget getSelectedContainer() {
    switch (selectedIndex) {
      case 0:
        return Container(
          width: 236.w,
          height: 360.h,
          padding: EdgeInsets.only(top: 16, bottom: 16),
          decoration: ShapeDecoration(
            color: Color(0xFF242424),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
            child: SvgPicture.network(
              "https://ceckhzfboykmsshamikv.supabase.co/storage/v1/object/public/image//advertisement_1.svg",
              // 네트워크 SVG 이미지 경로
              fit: BoxFit.contain, // 이미지 크기 조정
            ),
          ),
        );

      case 1:
        return Container(
          width: 236.w,
          height: 360.h,
          padding: EdgeInsets.only(top: 16, bottom: 16),
          decoration: ShapeDecoration(
            color: Color(0xFF242424),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 236.w,
                height: 328.h,
                padding:
                EdgeInsets.only(top: 24, bottom: 24, right: 16, left: 16),
                child: Column(
                  children: [
                    Container(
                      width: 204.w,
                      height: 56.h,
                      child: Text(
                        '58% 패션인들의 선택\n왜 스트릿일까 ?',
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
                    SizedBox(height: 24.h),
                    Container(
                      width: 204.w,
                      height: 204.h,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: DonutChart(
                        size: 204,
                        // 원하는 도넛 크기 지정
                        strokeWidth: 20,
                        total: 100,
                        value: 58,
                        child: Text(
                          '58%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF05FFF7),
                            fontSize: 24.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.40.h,
                            letterSpacing: -0.60,
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

      case 2:
        return Container(
          width: 236.w,
          height: 360.h,
          padding: EdgeInsets.only(top: 16, bottom: 16),
          decoration: ShapeDecoration(
            color: Color(0xFF242424),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
            child: SvgPicture.network(
              "https://ceckhzfboykmsshamikv.supabase.co/storage/v1/object/public/image//advertisement_3.svg",
              // 네트워크 SVG 이미지 경로
              fit: BoxFit.contain, // 이미지 크기 조정
            ),
          ),
        );

      case 3:
        return Container(
          width: 236.w,
          height: 360.h,
          padding: EdgeInsets.only(top: 16, bottom: 16),
          decoration: ShapeDecoration(
            color: Color(0xFF242424),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
            child: SvgPicture.network(
              "https://ceckhzfboykmsshamikv.supabase.co/storage/v1/object/public/image//advertisement_4.svg",
              // 네트워크 SVG 이미지 경로
              fit: BoxFit.contain, // 이미지 크기 조정
            ),
          ),
        );

      default:
        return Container(); // 기본값
    }
  }
  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // 디자인 사이즈 초기화
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
                  //광고바
                  Container(
                    width: 360.w,
                    height: 460.h,
                    padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                    child: Column(
                      children: [
                        Container(
                          width: 360.w,
                          height: 360.h,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            children: [
                              getSelectedContainer(),
                              SizedBox(width: 8.w),
                              SingleChildScrollView(
                                child: Column(
                                  children: List.generate(4, (index) {
                                    // index별로 다른 이미지 경로 설정
                                    List<String> imagePaths = [
                                      "https://ceckhzfboykmsshamikv.supabase.co/storage/v1/object/public/image//advertisement_1.svg",
                                      "https://ceckhzfboykmsshamikv.supabase.co/storage/v1/object/public/image//advertisement_2.svg",
                                      "https://ceckhzfboykmsshamikv.supabase.co/storage/v1/object/public/image//advertisement_3.svg",
                                      "https://ceckhzfboykmsshamikv.supabase.co/storage/v1/object/public/image//advertisement_4.svg",
                                    ];

                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          child: Container(
                                            width: 84.w,
                                            height: 106.h,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1.w,
                                                  color: selectedIndex == index
                                                      ? Color(
                                                      0xFF05FFF7) // 선택된 경우 다른 색상
                                                      : Color(0xFF1A1A1A),
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              shadows: [
                                                BoxShadow(
                                                  color: Color(0x26000000),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(8.w),
                                              child: SvgPicture.network(
                                                imagePaths[index],
                                                // 모든 이미지를 네트워크 SVG 이미지로 사용
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // 각 버튼 사이에 8의 간격을 주기 위한 SizedBox
                                        if (index < 3) SizedBox(height: 8.h),
                                        // 마지막 버튼 이후에는 간격을 주지 않음
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 360.w,
                          height: 52.h,
                          padding: EdgeInsets.all(16),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(1.00, -0.08),
                              end: Alignment(-1, 0.08),
                              colors: [Color(0xFF242424), Color(0x4C242424)],
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.w, color: Color(0xFF242424)),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Text(
                            '지금 확인하기',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF05FFF7),
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

                  CarouselSlider(
                    options: CarouselOptions(
                      height: 158.h,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: true,
                      autoPlay: true, // 자동 재생 활성화
                      autoPlayInterval: Duration(seconds:4), // 2초마다 이동
                      autoPlayAnimationDuration: Duration(milliseconds: 800), // 이동 애니메이션 속도 (선택 사항)

                    ),
                    items: pages.map((page) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: buildPage(page['image']!, page['text']!),
                          );
                        },
                      );
                    }).toList(),
                  ),

                  //middleText('바로가기'),
                  //아이콘 모음
                  // Container(
                  //   width: 360.w,
                  //   height: 192.h,
                  //   color: Color(0xFF1A1A1A),
                  //   padding:
                  //   EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         width: 160.w,
                  //         height: 160.h,
                  //         child: Column(
                  //           children: [
                  //             Container(
                  //               width: 160.w,
                  //               height: 76.h,
                  //               child: Row(
                  //                 children: [
                  //                   Container(
                  //                     width: 76.w,
                  //                     height: 76.h,
                  //                     color: Color(0xFF3F3F3F),
                  //                   ),
                  //                   SizedBox(width: 8.w),
                  //                   Container(
                  //                       width: 76.w,
                  //                       height: 76.h,
                  //                       color: Color(0xFF3F3F3F)),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(height: 8.h),
                  //             Container(
                  //               width: 160.w,
                  //               height: 76.h,
                  //               color: Color(0xFF3F3F3F),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(width: 8.w),
                  //       Container(
                  //         width: 160.w,
                  //         height: 160.h,
                  //         decoration: ShapeDecoration(
                  //           color: Color(0xFF3F3F3F),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(16),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(height: 24.h),

                  middleText('매장추천'),
                  // Container(
                  //   width: 360.w,
                  //   height: 56.h,
                  //   padding:
                  //   EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                  //   child: SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: Row(
                  //       children: [
                  //         Container(
                  //           width: 108.w,
                  //           height: 32.h,
                  //           decoration: ShapeDecoration(
                  //             color: Colors.white,
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(100),
                  //             ),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               '모디랑 추천매장',
                  //               style: TextStyle(
                  //                 color: Color(0xFF1A1A1A),
                  //                 fontSize: 12.sp,
                  //                 fontFamily: 'Pretendard',
                  //                 fontWeight: FontWeight.w700,
                  //                 height: 1.30.h,
                  //                 letterSpacing: -0.30,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(width: 12.w),
                  //         Container(
                  //           width: 108.w,
                  //           height: 32.h,
                  //           decoration: ShapeDecoration(
                  //             shape: RoundedRectangleBorder(
                  //               side: BorderSide(
                  //                   width: 1.w, color: Color(0xFF3D3D3D)),
                  //               borderRadius: BorderRadius.circular(100),
                  //             ),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               '지금 뜨는 매장',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 12.sp,
                  //                 fontFamily: 'Pretendard',
                  //                 fontWeight: FontWeight.w500,
                  //                 height: 1.30.h,
                  //                 letterSpacing: -0.30,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(width: 12.w),
                  //         Container(
                  //           width: 108.w,
                  //           height: 32.h,
                  //           decoration: ShapeDecoration(
                  //             shape: RoundedRectangleBorder(
                  //               side: BorderSide(
                  //                   width: 1.w, color: Color(0xFF3D3D3D)),
                  //               borderRadius: BorderRadius.circular(100),
                  //             ),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               '유저가 추천하는',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 12.sp,
                  //                 fontFamily: 'Pretendard',
                  //                 fontWeight: FontWeight.w500,
                  //                 height: 1.30.h,
                  //                 letterSpacing: -0.30,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(width: 12.w),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Container(
                    height: 246.h,
                    padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 20),
                    child: SingleChildScrollView(
                      //scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            width: 150.w,
                            height: 218.h,
                            child: Column(
                              children: [
                                Container(
                                  width: 150.w,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF797777),
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: AssetImage('assets/image/store_test01.png'),
                                      fit: BoxFit.cover, // 이미지가 컨테이너를 어떻게 채울지 설정 (선택 사항)
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: 150.w,
                                  height: 60.h,
                                  padding: EdgeInsets.only(left: 4,right: 8),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 138.w,
                                        height: 20.h,
                                        child: Text(
                                          '비스토어 쇼룸점',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            height: 1.40,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        width: 138.w,
                                        height: 16.h,
                                        child: Text(
                                          '대구 중구 삼덕동1가 18-9',
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
                                      SizedBox(height: 4),
                                      Container(
                                        width: 138.w,
                                        height: 16.h,
                                        child: Text(
                                          '영업 마감 · 12 : 00 | 21 : 30',
                                          style: TextStyle(
                                            color: Color(0xFF888888),
                                            fontSize: 12.sp,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            height: 1.30,
                                            letterSpacing: -0.30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                      ),
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


Widget buildPage(String imagePath, String text) {
  return Stack(
    children: [
      Container(
        width: 312.w,
        height: 126.h,
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
        ),
      ),
      Positioned(
        top: 62.h,
        left: 16.w,
        right: 16.w,
        bottom: 8.h,
        child: Container(
          width: 280.w,
          height: 56.h,
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFFF6F6F6),
              fontSize: 20.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.40,
              letterSpacing: -0.50,
            ),
          ),
        ),
      ),
    ],
  );
}