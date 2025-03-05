import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/designSize.dart';

class BirthdateTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onChanged; // 상태 갱신을 위한 콜백

  const BirthdateTextField({
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
          height: 64.h, // 높이는 .h 단위 유지
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 8, // 세로 패딩은 고정값 유지
          ),
          child: Container(
            width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
            height: 56.h, // 높이는 .h 단위 유지
            padding: EdgeInsets.only(left: 16,right: 16), // 패딩을 반응형으로 통일
            decoration: ShapeDecoration(
              color: Color(0xFF242424),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                      BirthdateInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(color: Color(0xFF888888), fontSize: 14.sp),
                    ),
                    onChanged: (value) {
                      if (onChanged != null) onChanged!();
                    },
                  ),
                ),
                if (controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.cancel, color: Color(0xFF888888)),
                    onPressed: () {
                      controller.clear();
                      if (onChanged != null) onChanged!();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// BirthdateInputFormatter 클래스 (예시로 포함)
class BirthdateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll('-', '');
    if (text.length > 8) {
      text = text.substring(0, 8);
    }
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      formatted += text[i];
      if (i == 3 || i == 5) {
        if (text.length > i + 1) formatted += '-';
      }
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CustomEmailField extends StatefulWidget {
  final TextEditingController controller;
  const CustomEmailField({Key? key, required this.controller}) : super(key: key);

  @override
  _CustomEmailFieldState createState() => _CustomEmailFieldState();
}
class _CustomEmailFieldState extends State<CustomEmailField> {
  bool _isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _isTextFieldEmpty = widget.controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 80.h,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24),
          child: Container(
            width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
            height: 56.h,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: const Color(0xFF242424),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.40,
                      letterSpacing: -0.35,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '이메일',
                      hintStyle: TextStyle(
                        color: const Color(0xFF888888),
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.40,
                        letterSpacing: -0.35,
                      ),
                    ),
                  ),
                ),
                if (!_isTextFieldEmpty)
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.cancel, color: Color(0xFF888888)),
                      onPressed: () {
                        widget.controller.clear();
                        setState(() {
                          _isTextFieldEmpty = true;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  const CustomPasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}
class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 80.h,
      padding:  EdgeInsets.only(left: 16.w, right: 16.w, top: 24),
      child: Container(
        width: 328.w,
        height: 56.h,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: const Color(0xFF242424),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.40,
                  letterSpacing: -0.35,
                ),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '여기에 입력하세요',
                  hintStyle: TextStyle(
                    color: const Color(0xFF888888),
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.40,
                    letterSpacing: -0.35,
                  ),
                ),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              alignment: Alignment.center,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF888888),
                ),
                iconSize: 24.sp,
                onPressed: _togglePasswordVisibility,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

