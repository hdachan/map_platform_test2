import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/auth_service.dart'; // AuthService 임포트
import '../utils/designSize.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';

class password_findScreen extends StatefulWidget {
  @override
  _password_findScreenState createState() => _password_findScreenState();
}

class _password_findScreenState extends State<password_findScreen> with SingleTickerProviderStateMixin {
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
                  CustomloginAppBar(title: '비밀번호 재설정', context: context),
                  Signuptext('이메일 입력', '비밀번호를 재설정하기 위해 이메일을 입력해주세요'),
                  CustomEmailField(controller: _emailController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}