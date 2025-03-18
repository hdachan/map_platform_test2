import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/cutstom_appbar.dart';

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

  // 관심 매장 불러오기 함수
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

  // 관심 매장 불러와서 상태 업데이트
  Future<void> _loadFavoriteStores() async {
    final stores = await _fetchFavoriteStores();
    setState(() {
      favoriteStores = stores;
    });
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
                              Icon(Icons.call_outlined, color: Colors.grey, size: 20),
                              Icon(Icons.subdirectory_arrow_right_rounded, color: Colors.grey, size: 20),
                              Icon(Icons.ios_share_outlined, color: Colors.grey, size: 20),
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