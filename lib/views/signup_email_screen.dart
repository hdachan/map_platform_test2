import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/auth_service.dart'; // AuthService 임포트
import '../utils/designSize.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'signup_password_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  bool _isTextFieldEmpty = true;
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService(); // AuthService 인스턴스 생성

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
    if (!_authService.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('유효한 이메일 주소를 입력하세요.')),
      );
      return;
    }

    // 이메일 중복 검사
    final isAvailable = await _authService.checkEmailAvailability(email);
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 등록된 이메일입니다.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // 디자인 사이즈 기준 초기화
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600), // 최대 너비 600px 제한
              child: Column(
                children: [
                  CustomAppBar(title: '모디랑 회원가입', context: context),
                  Signuptext('이메일 입력', '로그인에 사용할 이메일을 입력해주세요'),
                  emailInputLabel('이메일을 입력해주세요'),
                  SizedBox(height: 8.h),
                  CustomEmailField(controller: _emailController),
                  SizedBox(height: 300.h),
                  if (kIsWeb)
                    LoginButton(
                      buttonText: '다음',
                      onTap: () => _navigateToPasswordScreen(context),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: !kIsWeb
          ? LoginButton(
        buttonText: '다음',
        onTap: () => _navigateToPasswordScreen(context),
      )
          : null,
    );
  }
}