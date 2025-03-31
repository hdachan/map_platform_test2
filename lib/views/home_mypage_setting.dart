import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutstom_appbar.dart';
import 'home_mypage_Withdrawal_Screen.dart';
import 'login_selection_screen.dart';

class Setting1 extends StatefulWidget {
  @override
  _Setting1 createState() => _Setting1();
}

class _Setting1 extends State<Setting1> with SingleTickerProviderStateMixin {
  bool toggleValue = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF242424),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '정말 로그아웃 하시겠습니까?',
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
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
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
                final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                try {
                  await authViewModel.signOut();
                  // 빌드 후 화면 이동
                  if (!mounted) return;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => login_total_screen()),
                          (Route<dynamic> route) => false,
                    );
                  });
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                } catch (e) {
                  print('Logout failed: $e');
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그아웃 실패: $e')),
                  );
                }
              },
              child: Text(
                '확인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.30,
                  letterSpacing: -0.30,
                ),
              ),
            ),
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
                      () async {
                    final Uri url = Uri.parse('https://holybaits-modir.notion.site/1a6a2688a39a80d18f4fe74fa96ca226?pvs=74');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      print('Could not launch $url');
                    }
                  },
                ),
                middleText('기타'),
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