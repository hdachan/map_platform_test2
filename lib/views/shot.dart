import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

final supabase = Supabase.instance.client;

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
    return MaterialApp(
      home: MarkerImageScreen(),
    );
  }
}

class MarkerImageScreen extends StatefulWidget {
  @override
  _MarkerImageScreenState createState() => _MarkerImageScreenState();
}

class _MarkerImageScreenState extends State<MarkerImageScreen> {
  int modirId1 = 1; // 첫 번째 마커 ID
  int modirId2 = 2; // 두 번째 마커 ID
  int modirId3 = 11; // 세 번째 마커 ID
  List<String> imageUrls1 = [];
  List<String> imageUrls2 = [];
  List<String> imageUrls3 = [];

  @override
  void initState() {
    super.initState();
    fetchImages(); // 처음 실행 시 이미지 불러오기
  }

  // ✅ 해당 modir_id의 이미지 불러오기
  Future<void> fetchImages() async {
    final response1 = await supabase
        .from('modir_images')
        .select('image_url')
        .eq('modir_id', modirId1);

    final response2 = await supabase
        .from('modir_images')
        .select('image_url')
        .eq('modir_id', modirId2);

    final response3 = await supabase
        .from('modir_images')
        .select('image_url')
        .eq('modir_id', modirId3);

    setState(() {
      if (response1.isNotEmpty) {
        imageUrls1 = response1.map((row) => row['image_url'] as String).toList();
      }
      if (response2.isNotEmpty) {
        imageUrls2 = response2.map((row) => row['image_url'] as String).toList();
      }
      if (response3.isNotEmpty) {
        imageUrls3 = response3.map((row) => row['image_url'] as String).toList();
      }
    });
  }

  // ✅ UI: 이미지 리스트 표시
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마커 이미지 보기')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('마커 1 이미지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            imageUrls1.isEmpty
                ? Center(child: Text('이미지가 없습니다.'))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: imageUrls1.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(imageUrls1[index], height: 150),
                );
              },
            ),
            SizedBox(height: 20),
            Text('마커 2 이미지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            imageUrls2.isEmpty
                ? Center(child: Text('이미지가 없습니다.'))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: imageUrls2.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(imageUrls2[index], height: 150),
                );
              },
            ),
            SizedBox(height: 20),
            Text('마커 3 이미지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            imageUrls3.isEmpty
                ? Center(child: Text('이미지가 없습니다.'))
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: imageUrls3.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(imageUrls3[index], height: 150),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
