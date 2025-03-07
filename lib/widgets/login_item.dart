import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/designSize.dart';


Widget HomeScreenAppBar() {
  return Container(
    width: 360.w,
    height: 164.h,
    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h, bottom: 24.h),
    child: Column(
      children: [
        Container(
          width: 328.w,
          height: 64.h,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '모디랑',
                  style: TextStyle(
                    color: Color(0xFF05FFF7),
                    fontSize: 24.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.30.h,
                    letterSpacing: -0.60,
                  ),
                ),
                TextSpan(
                  text: '에서 다양한\n매장 정보를 확인하세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.30.h,
                    letterSpacing: -0.60,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 328.w,
          height: 40.h,
          child: Text(
            '실시간으로 업데이트 되는 매장 입고 브랜드와 함께\n팝업 스토어 정보까지 확인하세요',
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
      ],
    ),
  );
}

Widget CustomInkWell({required BuildContext context, required String imagePath, required Widget targetScreen,}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    },
    borderRadius: BorderRadius.circular(12.w), // 원형 효과를 위해 borderRadius 설정
    child: Container(
      width: 328.w,
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(24.w), // Container에도 borderRadius 설정
      ),
      child: SvgPicture.asset(
        imagePath,
        fit: BoxFit.fill,
      ),
    ),
  );
}


class LoginOptionsRow extends StatefulWidget {
  const LoginOptionsRow({Key? key}) : super(key: key);

  @override
  _LoginOptionsRowState createState() => _LoginOptionsRowState();
}

class _LoginOptionsRowState extends State<LoginOptionsRow> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 24.h,
          padding:  EdgeInsets.only(left: 16.w, right: 16),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  width: ResponsiveUtils.getResponsiveWidth(24, 360, constraints),
                  height: 24.h,
                  child: Icon(
                    isChecked ? Icons.check : Icons.check_box_outline_blank,
                    color: isChecked ? const Color(0xFF888888) : Colors.grey,
                    size: 24.sp,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: ResponsiveUtils.getResponsiveWidth(131, 360, constraints),
                height: 20.h,
                child: Text(
                  '자동 로그인',
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
              const SizedBox(width: 8),
              Container(
                width: ResponsiveUtils.getResponsiveWidth(70, 360, constraints),
                height: 20.h,
                child: Text(
                  '아이디 찾기',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.40,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: ResponsiveUtils.getResponsiveWidth(77, 360, constraints),
                height: 20.h,
                child: Text(
                  '비밀번호 찾기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.40,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
