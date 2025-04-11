import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled114/views/test/FeedScreen.dart';
import '../services/FeedService.dart';
import '../viewmodels/test/FeedViewModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FeedViewModel(FeedRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'StyleMap Feed',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const FeedScreen(),
      ),
    );
  }
}
