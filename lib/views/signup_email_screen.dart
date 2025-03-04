import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/designSize.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import '../widgets/login_item.dart';

class SignUp_screen extends StatefulWidget {
  @override
  _SignUp_screen createState() => _SignUp_screen();
}

class _SignUp_screen extends State<SignUp_screen>
    with SingleTickerProviderStateMixin {
  bool _isTextFieldEmpty = true;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _isTextFieldEmpty = _emailController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _navigateToPasswordScreen(BuildContext context) async {
    final email = _emailController.text.trim();

    // 이메일 빈 칸 검사
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 주소를 입력하세요.')),
      );
      return;
    }

    // 이메일 형식 검사
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('유효한 이메일 주소를 입력하세요.')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('userinfo')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 등록된 이메일입니다.')),
        );
        return;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다. 잠시 후 다시 시도해주세요.')),
      );
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // 디자인 사이즈 기준 초기화
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, // 최대 너비 600px 제한
              ),
              child: Column(
                children: [
                  CustomAppBar(title: '모디랑 회원가입', context: context),
                  Signuptext('이메일 입력', '로그인에 사용할 이메일을 입력해주세요'),
                  emailInputLabel('이메일을 입력해주세요'), // 원하는 텍스트 전달
                  SizedBox(height: 8.h),
                  CustomEmailField(controller: _emailController),
                  SizedBox(height: 300.h),
                  // 이 부분은 웹에서만 표시됨
                  if (kIsWeb)
                    LoginButton(
                      buttonText: '다음1',
                      onTap: () => _navigateToPasswordScreen(context),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
      // 이 부분은 모바일에서만 표시됨
      bottomNavigationBar: !kIsWeb
          ? LoginButton(
              buttonText: '다음1',
              onTap: () => _navigateToPasswordScreen(context),
            )
          : null,
    );
  }
}
