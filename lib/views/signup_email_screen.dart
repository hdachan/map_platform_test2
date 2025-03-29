import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Provider 임포트 추가
import '../viewmodels/login_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'signup_password_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(
              () => _isButtonEnabled = _emailController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _checkEmailAndNavigate(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final email = _emailController.text.trim();

    if (!await authViewModel.validateAndCheckEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authViewModel.errorMessage ?? '오류가 발생했습니다.')),
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
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
                      onTap: _isButtonEnabled
                          ? () => _checkEmailAndNavigate(context)
                          : () {},
                    )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: !kIsWeb
          ? LoginButton(
        buttonText: '다음',
        onTap: _isButtonEnabled
            ? () => _checkEmailAndNavigate(context)
            : () {},
      )
          : null,
    );
  }
}