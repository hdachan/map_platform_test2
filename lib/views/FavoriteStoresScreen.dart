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
  List<Map<String, dynamic>> favoriteStores = []; // 관심 매장 리스트

  @override
  void initState() {
    super.initState();
    _loadFavoriteStores();
  }

  // 관심 매장 불러오기
  Future<void> _loadFavoriteStores() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print("로그인이 필요합니다.");
      return;
    }

    final response = await _supabase
        .from('favorites')
        .select('store_id, modir(title, address, roadAddress, mapx, mapy)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    setState(() {
      favoriteStores = response.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        children: [
          CustomAppBar(title: '관심매장', context: context),
          Expanded(
            child: favoriteStores.isEmpty
                ? Center(child: Text("관심 등록한 매장이 없습니다.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: favoriteStores.length,
              itemBuilder: (context, index) {
                final store = favoriteStores[index];
                return ListTile(
                  title: Text(store['modir']['title'], style: TextStyle(color: Colors.white)),
                  subtitle: Text(store['modir']['roadAddress'] ?? store['modir']['address'], style: TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      await _supabase
                          .from('favorites')
                          .delete()
                          .eq('user_id', _supabase.auth.currentUser!.id)
                          .eq('store_id', store['store_id']);

                      _loadFavoriteStores(); // 삭제 후 목록 새로고침
                    },
                  ),
                  onTap: () {
                    print("매장 선택: ${store['modir']['title']}");
                  },
                );
              },
            ),
          ),
        ],
      ),
      ),
      backgroundColor: Color(0xFF1A1A1A),
    );
  }
}
