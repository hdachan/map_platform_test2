import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../viewmodels/withdrawal_view_model.dart';
import '../widgets/cutstom_appbar.dart';


class WithdrawalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WithdrawalViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                CustomAppBar(title: '탈퇴하기', context: context),
                Container(
                  width: 360.w,
                  height: 130.h,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 328.w,
                        child: Text(
                          '모디랑 서비스를 이용해주신 지난 날들을\n진심으로 감사하게 생각합니다.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.40,
                            letterSpacing: -0.45,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 328.w,
                        child: Text(
                          '고객님이 느끼신 불편한 점들을 저희에게 알려주신다면\n더욱 도움이 되는 서비스를 제공할 수 있도록 하겠습니다.',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.40,
                            letterSpacing: -0.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 360.w,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: List.generate(viewModel.reasons.length, (index) {
                      bool isSelected = viewModel.selectedIndexes.contains(index);
                      bool isOther = index == viewModel.reasons.length - 1;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => viewModel.toggleReason(index),
                            child: Container(
                              width: 360.w,
                              height: 36.h,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: ShapeDecoration(
                                      color: isSelected ? Color(0xFF05FFF7) : Color(0xFF3D3D3D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: isSelected ? Colors.black : Colors.white,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 300.w,
                                    child: Text(
                                      viewModel.reasons[index],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Color(0xFF888888),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.40,
                                        letterSpacing: -0.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isOther && isSelected)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: TextField(
                                controller: viewModel.otherReasonController,
                                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                decoration: InputDecoration(
                                  hintText: "기타 사유를 입력해주세요",
                                  hintStyle: TextStyle(color: Color(0xFF888888)),
                                  filled: true,
                                  fillColor: Color(0xFF3D3D3D),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () => viewModel.saveWithdrawalReason(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(328.w, 48.h),
                  ),
                  child: Text(
                    "탈퇴하기",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
