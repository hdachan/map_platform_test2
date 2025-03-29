import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled114/services/auth_service.dart';
import 'package:untitled114/utils/constants.dart';
import 'package:untitled114/config/app_config.dart';
import 'package:untitled114/viewmodels/data_viewmodel.dart';
import 'package:untitled114/viewmodels/login_viewmodel.dart';
import 'package:untitled114/viewmodels/map_viewmodel.dart';
import 'package:untitled114/viewmodels/profile_view_model.dart';
import 'package:untitled114/viewmodels/setting_viewmodel.dart';
import 'package:untitled114/views/home_screen.dart';
import 'package:untitled114/views/login_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      autoRefreshToken: true, // 세션 자동 갱신 활성화
    ),
  );

  await AppConfig.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()), // AuthService 제공
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SettingState()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => DataViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(),
      ),
    );
  }
}

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
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('오류: ${snapshot.error}')));
        }
        if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          });
          return SizedBox();
        }
        return login_total_screen();
      },
    );
  }
}