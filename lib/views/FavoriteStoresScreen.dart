import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/cutstom_appbar.dart';
import '../utils/RouteFinderPage.dart'; // navigateToDestination이 정의된 파일 (필요 시)

class FavoriteStoresScreen extends StatefulWidget {
  const FavoriteStoresScreen({Key? key}) : super(key: key);

  @override
  _FavoriteStoresScreenState createState() => _FavoriteStoresScreenState();
}

class _FavoriteStoresScreenState extends State<FavoriteStoresScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> favoriteStores = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStores();
  }

  Future<List<Map<String, dynamic>>> _fetchFavoriteStores() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print("로그인이 필요합니다.");
      return [];
    }

    final response = await _supabase
        .from('favorites')
        .select('store_id, modir(title, address, roadAddress, mapx, mapy)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
  }

  Future<void> _loadFavoriteStores() async {
    final stores = await _fetchFavoriteStores();
    setState(() {
      favoriteStores = stores;
    });
  }

  Future<void> navigateToDestination(double latitude, double longitude, String destinationName, {String? address}) async {
    try {
      // 간소화된 버전: API 호출 없이 바로 좌표 사용
      double endLat = double.parse(latitude.toStringAsFixed(7));
      double endLng = double.parse(longitude.toStringAsFixed(7));

      final appUrl = Uri.parse(
        "nmap://place?lat=$endLat&lng=$endLng&name=${Uri.encodeComponent(destinationName)}&appname=com.example.untitled114",
      );

      final webUrl = Uri.parse(
        "https://map.naver.com/v5/search/$destinationName?lat=$endLat&lng=$endLng",
      );

      bool canLaunchApp = await canLaunchUrl(appUrl);
      if (canLaunchApp) {
        await launchUrl(appUrl);
      } else {
        bool canLaunchWeb = await canLaunchUrl(webUrl);
        if (canLaunchWeb) {
          await launchUrl(webUrl);
        }
      }
    } catch (e) {
      print('Error navigating to destination: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: '관심매장', context: context),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: favoriteStores.isEmpty
                    ? Center(child: Text("관심 등록한 매장이 없습니다.", style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  itemCount: favoriteStores.length,
                  itemBuilder: (context, index) {
                    final store = favoriteStores[index];
                    return Column(
                      children: [
                        Container(
                          width: 360,
                          height: 128,
                          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 212,
                                height: 108,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store['modir']['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '영업 중 · 21:30에 영업 종료',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      store['modir']['address'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 108,
                                height: 108,
                                decoration: BoxDecoration(
                                  color: Color(0xFF797777),
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    image: AssetImage('assets/image/test_image.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 360,
                          height: 44,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFF242424)),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite, color: Colors.red, size: 20),
                                onPressed: () async {
                                  await _supabase
                                      .from('favorites')
                                      .delete()
                                      .eq('user_id', _supabase.auth.currentUser!.id)
                                      .eq('store_id', store['store_id']);
                                  _loadFavoriteStores();
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  // mapy와 mapx가 String일 경우 double로 변환
                                  double latitude = double.tryParse(store['modir']['mapy'].toString()) ?? 0.0;
                                  double longitude = double.tryParse(store['modir']['mapx'].toString()) ?? 0.0;
                                  navigateToDestination(
                                    latitude,
                                    longitude,
                                    store['modir']['title'],
                                    address: store['modir']['address'],
                                  );
                                },
                                child: Container(
                                  width: 36.w,
                                  height: 36.h,
                                  child: Transform.rotate(
                                    angle: -0.785,
                                    child: Icon(
                                      Icons.subdirectory_arrow_right_rounded,
                                      color: Colors.grey,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF1A1A1A),
    );
  }
}