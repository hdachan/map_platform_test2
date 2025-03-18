import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../utils/designSize.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/cutstom_appbar.dart';
import '../widgets/login_item.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 버튼 클릭 시 뷰모델의 로그인 메서드를 호출
  Future<void> _handleSignIn() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final errorMessage = await authViewModel.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 성공!')),

      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // HomeScreen 대신 HomeMain1
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // designSize.dart의 초기화 함수
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomloginAppBar(title: '로그인', context: context),
                  SizedBox(height: 20.h),
                  CustomEmailField1(controller: _emailController),
                  CustomPasswordField(controller: _passwordController),
                  SizedBox(height: 24.h),
                  LoginOptionsRow(),
                  if (kIsWeb)
                    LoginButton(
                      buttonText: '로그인',
                      onTap: () => _handleSignIn(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: !kIsWeb
          ? LoginButton(
        buttonText: '로그인',
        onTap: () => _handleSignIn(),
      )
          : null,
    );
  }
}
