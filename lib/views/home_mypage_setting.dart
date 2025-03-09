import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'login_screen.dart';

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
                  _logout, // 로그아웃 함수 호출
                ),
                customButton(
                  '탈퇴하기',
                      () {
                    print('버튼이 클릭되었습니다!');
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