import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/animation.dart';
import '../utils/designSize.dart';
import '../views/FavoriteStoresScreen.dart';
import '../views/home_navermap_search_screen.dart';



Widget searchBar(BuildContext context, BoxConstraints constraints) {
  return Container(
    width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
    height: 48.h,
    padding: const EdgeInsets.only(top: 6, bottom: 6),
    child: Container(
      width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
      height: 36.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                createSlideUpRoute(SearchScreen()),
              );
            },
            child: Container(
              width: ResponsiveUtils.getResponsiveWidth(284, 360, constraints),
              height: 36.h,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: ShapeDecoration(
                color: const Color(0xFF3D3D3D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: const Color(0xFF888888),
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      '매장, 위치 검색',
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
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                createFadeRoute(FavoriteStoresScreen()),
              );
            },
            child: Container(
              width: ResponsiveUtils.getResponsiveWidth(36, 360, constraints),
              height: 36.h,
              padding: const EdgeInsets.all(6),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.storefront_outlined,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



class CurrentLocationButton extends StatelessWidget {
  final double buttonTop;
  final Function() onTap;

  const CurrentLocationButton({
    Key? key,
    required this.buttonTop,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: buttonTop,
      left: MediaQuery.of(context).size.width / 2 - 190,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: ShapeDecoration(
            color: Color(0xB2242424),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.my_location_outlined, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
