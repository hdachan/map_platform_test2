// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled114/services/auth_service.dart';
import 'package:untitled114/views/home_main.dart';
import 'package:untitled114/views/home_screen.dart';
import 'package:untitled114/views/login_selection_screen.dart';

import 'config/app_config.dart';
import 'viewmodels/data_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/map_viewmodel.dart';
import 'viewmodels/profile_view_model.dart';
import 'viewmodels/setting_viewmodel.dart';
import 'utils/constants.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  await AppConfig.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => SettingState()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => DataViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),//
        ChangeNotifierProvider(create: (_) => AuthService()),//AuthService
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(), // 동적 초기 화면 설정
      ),
    );
  }
}

// 인증 상태에 따라 화면 분기
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return FutureBuilder<bool>(
      future: authViewModel.checkSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data == true) {
          // 로그인 후 로그인 화면을 제거하고 홈 화면으로 이동
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false, // 모든 이전 화면 제거
            );
          });
          return SizedBox(); // 화면 깜빡임 방지용 빈 위젯
        }
        return login_total_screen(); // 세션이 없으면 로그인 화면
      },
    );
  }
}


