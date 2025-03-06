// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled114/views/login_selection_screen.dart';

import 'config/app_config.dart';
import 'viewmodels/data_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/map_viewmodel.dart';
import 'viewmodels/setting_viewmodel.dart';
import 'utils/constants.dart';
import 'views/filter_provider.dart';
import 'views/home_main.dart';
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
        ChangeNotifierProvider(create: (_) => FilterProvider()), ///필터 상태
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: login_total_screen(),
      ),
    );
  }
}