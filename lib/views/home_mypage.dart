import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:untitled114/views/FavoriteStoresScreen.dart';
import 'package:untitled114/views/home_mypage_setting.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/animation.dart';
import '../utils/designSize.dart';
import '../viewmodels/profile_view_model.dart';
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
  void initState() {
    super.initState();
    Provider.of<ProfileViewModel>(context, listen: false).fetchUserInfo();
  }

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
              child: Consumer<ProfileViewModel>(
                builder: (context, profileVM, child) {
                  return Column(
                    children: [
                      custom_mypage_AppBar(
                        onNotificationTap: () {
                          print("알림 버튼 클릭됨");
                        },
                        onSettingsTap: () {
                          Navigator.push(
                            context,
                            createSlideLeftRoute(Setting1()), // ✅ 오른쪽 → 왼쪽 애니메이션 적용
                          );
                        },
                      ),
                      LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                createSlideLeftRoute(ProfileEditScreen()), // ✅ 오른쪽 → 왼쪽 애니메이션 적용
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 132.h,
                              padding: EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 16),
                              child: Container(
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
                                                      profileVM.nicknameController.text.isNotEmpty
                                                          ? profileVM.nicknameController.text
                                                          : '모디랑님',
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
                                                  child: Center(
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
                                            child: Text(
                                              profileVM.selectedGenderIndex == 0
                                                  ? '남성'
                                                  : (profileVM.selectedGenderIndex == 1 ? '여성' : '미설정'),
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
                                    text: profileVM.selectedCategoryIndex == 0
                                        ? '빈티지'
                                        : (profileVM.selectedCategoryIndex == 1 ? '아메카지' : '미설정'),
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
                      // 여기 넣는거임
                      SizedBox(height: 24.h),
                      // middleText('기록'),
                      // customButton(
                      //   '최근에 본 매장',
                      //       () {
                      //     // 버튼 클릭 시 수행할 작업을 여기에 작성하세요.
                      //     print('버튼이 클릭되었습니다!');
                      //   },
                      // ),
                      middleText('관심'),
                      customButton(
                        '관심 매장',
                            () {
                          Navigator.push(
                            context,
                            createSlideLeftRoute(FavoriteStoresScreen()), // ✅ 오른쪽 → 왼쪽 애니메이션 적용
                          );
                        },
                      ),
                      middleText('문의'),
                      customButton(
                        '사장님들 입점 문의하기!',
                            () async {
                          final Uri url = Uri.parse('https://forms.gle/hrkbBsHA5BphXiN77');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            print('Could not launch $url');
                          }
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
                      // customButton(
                      //   'FQA',
                      //       () {
                      //     // 버튼 클릭 시 수행할 작업을 여기에 작성하세요.
                      //     print('버튼22이 클릭되었습니다!');
                      //   },
                      // ),
                      customButton(
                        '1:1 문의하기',
                            () async {
                          final Uri url = Uri.parse('https://forms.gle/RfZyztPDJKZX4hnt7');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            print('Could not launch $url');
                          }
                        },
                      ),

                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
