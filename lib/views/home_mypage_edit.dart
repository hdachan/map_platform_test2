import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_field.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileViewModel>().fetchUserInfo();
      }
    });
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
              child: Consumer<ProfileViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.errorMessage != null) {
                    return Center(
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      CustomAppBar(title: '프로필 수정', context: context),
                      SizedBox(height: 16.h),

                      // 닉네임 입력 (✅ 수정된 부분)
                      LayoutBuilder(builder: (context, constraints) {
                        return Subtext('닉네임', constraints);
                      }),
                      SizedBox(height: 8.h),
                      CustomEmailField(
                        controller: viewModel.nicknameController,
                      ),
                      SizedBox(height: 16.h),

                      // 생년월일 입력
                      LayoutBuilder(builder: (context, constraints) {
                        return Subtext('생년월일', constraints);
                      }),
                      SizedBox(height: 8.h),
                      BirthdateTextField(
                        controller: viewModel.birthdateController,
                        hintText: 'YYYYMMDD 형식으로 입력하세요',
                        onChanged: viewModel.notifyListeners,
                      ),
                      SizedBox(height: 16.h),

                      // 성별 선택 버튼
                      LayoutBuilder(builder: (context, constraints) {
                        return Subtext('성별', constraints);
                      }),
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

                      // 카테고리 선택 버튼
                      LayoutBuilder(builder: (context, constraints) {
                        return Subtext('카테고리', constraints);
                      }),
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
      bottomNavigationBar: !kIsWeb
          ? Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return LoginButton(
            buttonText: '완료',
            onTap: () => viewModel.updateUserInfo(),
          );
        },
      )
          : null,
    );
  }
}
