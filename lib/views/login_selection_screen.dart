import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/designSize.dart';
import '../widgets/login_item.dart';
import 'login_password_find_screen.dart';
import 'login_screen.dart';
import 'signup_agree_screen.dart';

class login_total_screen extends StatefulWidget {
  @override
  _login_totalscreen createState() => _login_totalscreen();
}

class _login_totalscreen extends State<login_total_screen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // 디자인 사이즈 기준
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, // 최대 너비를 360px로 제한
              ),
              child: Column(
                children: [
                  HomeScreenAppBar(),
                  Container(
                    width: 360.w,
                    height: 478.h,
                    padding: EdgeInsets.only(
                        left: 16.w, right: 16.w, top: 254.h, bottom: 48.h),
                    child: Column(
                      children: [
                        CustomInkWell(
                          context: context, // 현재 context를 전달
                          imagePath: 'assets/image/goole_icon.svg',
                          targetScreen: password_findScreen(), // LoginScreen으로 이동
                        ),
                        SizedBox(height: 16.h),
                        CustomInkWell(
                          context: context, // 현재 context를 전달
                          imagePath: 'assets/image/kakaoh_icon.svg',
                          targetScreen: LoginScreen(), // LoginScreen으로 이동
                        ),
                        SizedBox(height: 16.h),
                        CustomInkWell(
                          context: context, // 현재 context를 전달
                          imagePath: 'assets/image/modir_logo_icon.svg',
                          targetScreen: LoginScreen(), // LoginScreen으로 이동
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 360.w,
                    height: 20.h,
                    child: Text(
                      '아직 회원이 아니예요',
                      textAlign: TextAlign.center,
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
                  Container(
                    width: 360.w,
                    height: 32.h,
                    child: Column(
                      children: [
                        Container(
                          width: 73.w,
                          height: 32.h,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AgreePage(),
                                ),
                              );
                            },
                            child: Text(
                              '회원가입',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 1.40.h,
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
          ),
        ),
      ),
    );
  }
}
