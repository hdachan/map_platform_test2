import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/designSize.dart';

class BirthdateTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onChanged;

  const BirthdateTextField({
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  _BirthdateTextFieldState createState() => _BirthdateTextFieldState();
}

class _BirthdateTextFieldState extends State<BirthdateTextField> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatInput);
  }

  void _formatInput() {
    String text = widget.controller.text.replaceAll(RegExp(r'\D'), ''); // 숫자만 유지
    if (text.length > 8) text = text.substring(0, 8); // 8자리 제한

    String formattedText = _formatDateString(text);
    if (widget.controller.text != formattedText) {
      widget.controller.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    _validateInput(formattedText);
  }

  String _formatDateString(String input) {
    if (input.length <= 4) return input; // 연도만 입력된 경우
    if (input.length <= 6) return '${input.substring(0, 4)}-${input.substring(4)}'; // YYYY-MM

    return '${input.substring(0, 4)}-${input.substring(4, 6)}-${input.substring(6, 8)}'; // YYYY-MM-DD
  }

  void _validateInput(String text) {
    if (text.length == 10 && _isValidDateFormat(text)) {
      setState(() => _errorText = null);
    } else {
      setState(() => _errorText = 'YYYY-MM-DD 형식으로 입력하세요');
    }
    if (widget.onChanged != null) widget.onChanged!();
  }

  bool _isValidDateFormat(String text) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) return false;

    final year = int.tryParse(text.substring(0, 4)) ?? 0;
    final month = int.tryParse(text.substring(5, 7)) ?? 0;
    final day = int.tryParse(text.substring(8, 10)) ?? 0;

    if (year < 1900 || year > DateTime.now().year) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: _errorText == null ? 64.h : 80.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56.h,
                padding: EdgeInsets.only(left: 16.w,right: 4.w),
                decoration: BoxDecoration(
                  color: Color(0xFF242424),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.transparent, // 빨간 테두리 제거
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: TextStyle(color: Color(0xFF888888), fontSize: 14.sp),
                        ),
                      ),
                    ),
                    if (widget.controller.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.cancel, color: Color(0xFF888888)),
                        onPressed: () {
                          widget.controller.clear();
                          _validateInput('');
                        },
                      ),
                  ],
                ),
              ),
              if (_errorText != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.w),
                  child: Text(
                    _errorText!,
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatInput);
    super.dispose();
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
          width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
          height: 80.h,
          padding: EdgeInsets.only(left: 16.w, right: 16.w,bottom: 24),
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

class CustomEmailField1 extends StatefulWidget {
  final TextEditingController controller;
  const CustomEmailField1({Key? key, required this.controller}) : super(key: key);

  @override
  _CustomEmailFieldState1 createState() => _CustomEmailFieldState1();
}
class _CustomEmailFieldState1 extends State<CustomEmailField1> {
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
          width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
          height: 80.h,
          padding: EdgeInsets.only(left: 16.w, right: 16.w,top: 24),
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

