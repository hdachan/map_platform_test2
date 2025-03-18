import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'home_mypage_Withdrawal_Screen.dart';
import 'login_screen.dart';
import 'login_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  runApp(MaterialApp(
    home: Setting1(),
  ));
}

class Setting1 extends StatefulWidget {
  @override
  _Setting1 createState() => _Setting1();
}

class _Setting1 extends State<Setting1> with SingleTickerProviderStateMixin {
  bool toggleValue = true; // 토글 상태를 관리하는 변수
// Supabase 클라이언트 인스턴스 가져오기
  final SupabaseClient supabase = Supabase.instance.client;

  // 로그아웃 함수
  Future<void> _logout() async {
    try {
      await supabase.auth.signOut(); // Supabase 로그아웃
      print('로그아웃 성공!');
      // 로그아웃 후 로그인 화면으로 이동 (필요 시)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // 로그인 화면으로 이동
      );
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF242424), // 배경색 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // 모서리 둥글게
          ),
          title: Text(
            '로그아웃',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.10,
              letterSpacing: -0.45,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // 내용에 맞게 크기 조정
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Text(
                '정말 로그아웃 하시겠습니까 ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                  letterSpacing: -0.30,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child:         Text(
                '취소',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                  letterSpacing: -0.30,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 팝업 닫기

                // 로그아웃 실행 후 완료될 때까지 기다림
                await Provider.of<AuthService>(context, listen: false).signOut();

                // 로그아웃 완료 후 로그인 화면으로 이동 (이전 스택 제거)
                if (!mounted) return; // 위젯이 이미 dispose된 경우 실행 방지
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => login_total_screen()),
                      (Route<dynamic> route) => false, // 모든 이전 화면 제거
                );
              },
              child: Text(
                '확인',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                  letterSpacing: -0.30,
                ),
              ),
            )



          ],
        );
      },
    );
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
                CustomAppBar(title: '환경설정', context: context),
                middleText('알림설정'),
                customPushButton(
                  '모디랑에서 보내는 공지',
                      () {
                    print('버튼이 클릭되었습니다!');
                  },
                  toggleValue: toggleValue,
                  onToggleChanged: (bool value) {
                    setState(() {
                      toggleValue = value;
                      print('토글 상태: $value');
                    });
                  },
                ),
                middleText('정보'),
                customButton(
                  '이용약관',
                      () {
                    print('버튼이 클릭되었습니다!');
                  },
                ),
                customButton(
                  '오픈 라이센스 확인하기',
                      () {
                    print('버튼이 클릭되었습니다!');
                  },
                ),
                middleText('기타'),
                customButton(
                  '오류신고',
                      () {
                    print('버튼이 클릭되었습니다!');
                  },
                ),
                customButton(
                  '로그아웃',
                      () => _showLogoutDialog(context),
                ),
                customButton(
                  '탈퇴하기',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WithdrawalScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}