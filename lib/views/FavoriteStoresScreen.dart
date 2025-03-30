import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/cutstom_appbar.dart';

class FavoriteStoresScreen extends StatefulWidget {
  const FavoriteStoresScreen({Key? key}) : super(key: key);

  @override
  _FavoriteStoresScreenState createState() => _FavoriteStoresScreenState();
}

class _FavoriteStoresScreenState extends State<FavoriteStoresScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> favoriteStores = [];
  Map<int, List<String>> storeImages = {};

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
        .select('store_id, modir(id, title, address, roadAddress, mapx, mapy)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
  }

  Future<List<String>> fetchImagesForModir(int modirId) async {
    try {
      final response = await _supabase
          .from('modir_images')
          .select('image_url')
          .eq('modir_id', modirId);
      return response.isNotEmpty
          ? response.map((row) => row['image_url'] as String).toList()
          : [];
    } catch (e) {
      print('Error fetching images for modir $modirId: $e');
      return [];
    }
  }

  Future<void> _loadFavoriteStores() async {
    final stores = await _fetchFavoriteStores();
    setState(() {
      favoriteStores = stores;
    });
    for (var store in stores) {
      final modirId = store['modir']['id'];
      final images = await fetchImagesForModir(modirId);
      setState(() {
        storeImages[modirId] = images;
      });
    }
  }

  Future<void> navigateToDestination(double latitude, double longitude, String destinationName, {String? address}) async {
    try {
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
                    final int modirId = store['modir']['id'];
                    final List<String> images = storeImages[modirId] ?? [];

                    return Column(
                      children: [
                        Container(
                          width: 360,
                          height: 128,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
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
                                      store['modir']['address'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
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
                                  borderRadius: BorderRadius.circular(4),
                                  image: images.isNotEmpty
                                      ? DecorationImage(
                                    image: NetworkImage(images.first),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                  color: images.isEmpty ? Colors.grey : null,
                                ),
                                child: images.isEmpty
                                    ? Center(child: Icon(Icons.image_not_supported, color: Colors.white))
                                    : null,
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
                              IconButton(
                                icon: Icon(Icons.directions, color: Colors.grey, size: 20),
                                onPressed: () {
                                  double latitude = double.tryParse(store['modir']['mapy'].toString()) ?? 0.0;
                                  double longitude = double.tryParse(store['modir']['mapx'].toString()) ?? 0.0;
                                  navigateToDestination(latitude, longitude, store['modir']['title']);
                                },
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
