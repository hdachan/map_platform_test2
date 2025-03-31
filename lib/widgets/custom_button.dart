import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/designSize.dart';
import '../viewmodels/FavoriteStoresViewModel.dart';

///로그인
//로그인 버튼
class LoginButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const LoginButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = ResponsiveUtils.getResponsiveWidth(328, 360, constraints);

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12),
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: buttonWidth,
                height: 44.h,
                decoration: ShapeDecoration(
                  color: Color(0xFF05FFF7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.40.h,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

///회원가입
Widget emailInputLabel(String text) {
  return Container(
    width: 360.w,
    height: 20.h,
    padding: EdgeInsets.only(left: 16.w, right: 16.h),
    child: Container(
      width: 328.w,
      height: 20.h,
      child: Text(
        text, // 전달받은 텍스트 사용
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
// 버튼 선택 위젯 (성별, 카테고리 공용)


Widget buildSelectionButtons(
    List<String> labels, int selectedIndex, Function(int) onPressed, BoxConstraints constraints) {
  return Container(
    width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
    height: 48.h,
    padding: EdgeInsets.only(left: 16.w, right: 16.w), // 최상위 패딩 유지
    child: Container(
      width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양옆으로 배치
        children: List.generate(labels.length, (index) {
          return InkWell(
            onTap: () => onPressed(index),
            child: Container(
              width: ResponsiveUtils.getResponsiveWidth(146, 360, constraints),
              height: 48.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: selectedIndex == index ? Color(0xFF05FFF7) : Color(0xFF888888),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: selectedIndex == index ? Color(0xFF05FFF7) : Color(0xFF888888),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

///마이페이지
//마이 페이지 버튼
Widget customButton(String title, VoidCallback onPressed) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 48.h,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(312, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.only(left: 16, top: 14, bottom: 14),
                child: Text(
                  title,
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
              Container(
                width: ResponsiveUtils.getResponsiveWidth(48, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget customPushButton(String title, VoidCallback onPressed, {required bool toggleValue, required ValueChanged<bool> onToggleChanged}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
        height: 48.h,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(312, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Text(
                  title,
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
              Container(
                width: ResponsiveUtils.getResponsiveWidth(48, 360, constraints),
                height: 48.h,
                padding: const EdgeInsets.all(12), // Switch 크기에 맞게 패딩 조정
                child: Switch(
                  value: toggleValue,
                  onChanged: onToggleChanged,
                  activeColor: Color(0xFF43FFE8),
                  inactiveThumbColor: Color(0xFF454545),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///네이버지도
// 네이버지도 새로고침 버튼
class RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const RefreshButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 141.w,
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: ShapeDecoration(
              color: Color(0xB2242424),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Center(
                    child: Icon(
                      Icons.refresh,
                      color: Color(0xFF05FFF7),
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                SizedBox(
                  width: 89.w,
                  height: 20.h,
                  child: Text(
                    '현 지도에서 검색',
                    style: TextStyle(
                      color: Colors.white,
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
        ),
      ),
    );
  }
}


final supabase = Supabase.instance.client;

// 이미지 가져오는 함수
Future<List<String>> fetchImagesForModir(int modirId) async {
  try {
    final response = await supabase
        .from('modir_images')
        .select('image_url')
        .eq('modir_id', modirId);
    return response.isNotEmpty
        ? response.map((row) => row['image_url'] as String).toList()
        : [];
  } catch (e) {
    print('Error fetching images for modir $modirId: $e');
    return [];
  }
}



/// 관심등록버튼


class FavoriteButton extends StatefulWidget {
  final int storeId;

  const FavoriteButton({Key? key, required this.storeId}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoriteButtonViewModel _viewModel = FavoriteButtonViewModel();

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      _viewModel.loadFavoriteStatus(user.id, widget.storeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return IconButton(
          icon: Icon(
            _viewModel.isFavorite ? Icons.favorite : Icons.favorite_outline,
            color: _viewModel.isFavorite ? Colors.red : Colors.grey,
            size: 20.sp,
          ),
          onPressed: () {
            final user = Supabase.instance.client.auth.currentUser;
            if (user != null) {
              _viewModel.toggleFavorite(user.id, widget.storeId);
            }
          },
        );
      },
    );
  }
}
