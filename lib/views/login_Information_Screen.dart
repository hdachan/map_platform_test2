import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../utils/designSize.dart';
import '../viewmodels/information_view_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'home_screen.dart';

class InformationScreen extends StatelessWidget {
  final String email;
  final String password;

  const InformationScreen({required this.email, required this.password});

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context);
    return ChangeNotifierProvider(
      create: (_) => InformationViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Consumer<InformationViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        CustomAppBar(title: '정보 입력', context: context),
                        Signuptext('정보입력', '활동하실 닉네임과 정보들을 입력해 주세요'),
                        SizedBox(height: 16.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Subtext('닉네임', constraints);
                          },
                        ),
                        SizedBox(height: 8.h),
                        CustomEmailField(controller: viewModel.nicknameController),
                        SizedBox(height: 16.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Subtext('생년월일', constraints);
                          },
                        ),
                        SizedBox(height: 8.h),
                        BirthdateTextField(
                          controller: viewModel.birthdateController,
                          hintText: 'YYYYMMDD 형식으로 입력하세요',
                          onChanged: () => viewModel.notifyListeners(),
                        ),
                        SizedBox(height: 16.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Subtext('성별', constraints);
                          },
                        ),
                        SizedBox(height: 8.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return buildSelectionButtons(
                              ['남자', '여자'],
                              viewModel.selectedGenderIndex,
                              viewModel.onGenderButtonPressed,
                              constraints,
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Subtext('카테고리', constraints);
                          },
                        ),
                        SizedBox(height: 8.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return buildSelectionButtons(
                              ['빈티지', '아메카지'],
                              viewModel.selectedCategoryIndex,
                              viewModel.onCategoryButtonPressed,
                              constraints,
                            );
                          },
                        ),
                        SizedBox(height: 32.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Consumer<InformationViewModel>(
          builder: (context, viewModel, child) {
            return LoginButton(
              buttonText: '완료',
              onTap: () async {
                final errorMessage = await viewModel.signUp(email, password);
                if (errorMessage == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}