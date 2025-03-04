import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 네이버지도 오버레이
void showCenteredSnackbar(BuildContext context, String message) {
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 328.w,
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xB2242424),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Color(0xFF05FFF7)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)?.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry?.remove();
  });
}
