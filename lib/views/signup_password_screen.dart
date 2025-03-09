import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/designSize.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';

class PasswordScreen extends StatefulWidget {
  final String email;

  const PasswordScreen({required this.email});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late final PasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PasswordViewModel();
    _passwordController.addListener(() {
      _viewModel.updatePassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _viewModel.dispose(); // ChangeNotifier의 dispose 호출
    super.dispose();
  }

  void _handleSubmit() {
    _viewModel.navigateToNextScreen(
      widget.email,
      _passwordController.text,
      _confirmPasswordController.text,
      context,
    );
    if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // 디자인 사이즈 초기화
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  CustomAppBar(title: '비밀번호 입력', context: context),
                  Signuptext('비밀번호 입력', '계정 생성을 위해 비밀번호를 입력해주세요'),
                  SizedBox(height: 8.h),
                  emailInputLabel('비밀번호를 입력해주세요'),
                  CustomPasswordField(controller: _passwordController),
                  SizedBox(height: 16.h),
                  AnimatedBuilder(
                    animation: _viewModel, // ViewModel의 변경 감지
                    builder: (context, child) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                            height: 156.h,
                            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                            child: Container(
                              width: ResponsiveUtils.getResponsiveWidth(328, 360, constraints),
                              height: 136.h,
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(1.00, -0.08),
                                  end: Alignment(-1, 0.08),
                                  colors: [Color(0xFF242424), Color(0x4C242424)],
                                ),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 20,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildPasswordHint(
                                    constraints,
                                    '영문, 숫자, 특수문자 조합하기',
                                    _viewModel.hasCombination(),
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildPasswordHint(
                                    constraints,
                                    '8자 이상 입력하기',
                                    _viewModel.isLongEnough(),
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildPasswordHint(
                                    constraints,
                                    '연속된 문자 사용하지 않기',
                                    _viewModel.hasNoConsecutiveChars(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  emailInputLabel('비밀번호 확인을 위해 한번 더 입력해 주세요'),
                  SizedBox(height: 8.h),
                  CustomPasswordField(controller: _confirmPasswordController),
                  SizedBox(height: 16.h),
                  if (kIsWeb)
                    LoginButton(
                      buttonText: '다음',
                      onTap: () => _handleSubmit(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: !kIsWeb
          ? LoginButton(
        buttonText: '정보입력',
        onTap: () => _handleSubmit(),
      )
          : null,
    );
  }

  Widget _buildPasswordHint(BoxConstraints constraints, String text, bool isValid) {
    return Container(
      width: ResponsiveUtils.getResponsiveWidth(296, 360, constraints),
      height: 24.h,
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.getResponsiveWidth(240, 360, constraints),
            height: 20.h,
            child: Text(
              text,
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
          Spacer(),
          if (isValid) // 조건이 충족될 때만 이미지 표시
            Container(
              width: ResponsiveUtils.getResponsiveWidth(24, 360, constraints),
              height: ResponsiveUtils.getResponsiveWidth(24, 360, constraints),
              child: Image.asset(
                'assets/image/check_icon.png',
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }
}