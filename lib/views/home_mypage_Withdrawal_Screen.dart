import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled114/views/login_selection_screen.dart';

import '../widgets/cutstom_appbar.dart';

class WithdrawalScreen extends StatefulWidget {
  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  List<String> reasons = [
    '잘 안사용하게 되는 것 같아요',
    '서비스 지연이 너무 심해요',
    '매장 찾는게 불편해요',
    '필요없는 내용이 너무 많아요',
    '기타'
  ];

  Set<int> selectedIndexes = {}; // 선택된 체크박스 저장
  TextEditingController otherReasonController = TextEditingController(); // 기타 입력 필드 컨트롤러

  Future<void> saveWithdrawalReason() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      print("사용자가 로그인되어 있지 않습니다.");
      return;
    }

    try {
      List<String> selectedReasonsList = selectedIndexes.map((index) => reasons[index]).toList();
      String? otherText = selectedIndexes.contains(reasons.length - 1) ? otherReasonController.text.trim() : null;

      for (String reason in selectedReasonsList) {
        await supabase.from('withdrawal_reasons').insert({
          'user_id': user.id,
          'reason': reason == '기타' ? otherText : reason,
        });
      }
      print("탈퇴 사유가 성공적으로 저장되었습니다.");

      // 탈퇴 후 로그인 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login_total_screen()), // Mmmm4는 이동할 화면의 위젯입니다.
      );
    } catch (e) {
      print("탈퇴 사유 저장 중 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    children: List.generate(reasons.length, (index) {
                      bool isSelected = selectedIndexes.contains(index);
                      bool isOther = index == reasons.length - 1; // '기타' 옵션 체크 확인

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedIndexes.remove(index);
                                } else {
                                  selectedIndexes.add(index);
                                }
                              });
                            },
                            child: Container(
                              width: 360.w,
                              height: 36.h,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  // 체크박스
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
                                  // 텍스트
                                  Container(
                                    width: 300.w,
                                    child: Text(
                                      reasons[index],
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
                          // 기타 옵션 선택 시 텍스트 필드 표시
                          if (isOther && isSelected)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: TextField(
                                controller: otherReasonController,
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
                  onPressed: saveWithdrawalReason,
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
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
