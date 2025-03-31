import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/FavoriteStoresViewModel.dart';
import '../widgets/cutstom_appbar.dart';

class FavoriteStoresScreen extends StatefulWidget {
  const FavoriteStoresScreen({Key? key}) : super(key: key);

  @override
  _FavoriteStoresScreenState createState() => _FavoriteStoresScreenState();
}

class _FavoriteStoresScreenState extends State<FavoriteStoresScreen> {
  final FavoriteStoresViewModel _viewModel = FavoriteStoresViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadFavoriteStores(); // ViewModel에서 데이터 로드
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
                child: AnimatedBuilder(
                  animation: _viewModel,
                  builder: (context, _) {
                    if (_viewModel.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return _viewModel.favoriteStores.isEmpty
                        ? Center(child: Text("관심 등록한 매장이 없습니다.", style: TextStyle(color: Colors.grey)))
                        : ListView.builder(
                      itemCount: _viewModel.favoriteStores.length,
                      itemBuilder: (context, index) {
                        final store = _viewModel.favoriteStores[index];
                        final int modirId = store['modir']['id'];
                        final List<String> images = _viewModel.storeImages[modirId] ?? [];

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
                                    onPressed: () => _viewModel.removeFavoriteStore(store['store_id']),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.directions, color: Colors.grey, size: 20),
                                    onPressed: () {
                                      double latitude = double.tryParse(store['modir']['mapy'].toString()) ?? 0.0;
                                      double longitude = double.tryParse(store['modir']['mapx'].toString()) ?? 0.0;
                                      _viewModel.navigateToDestination(latitude, longitude, store['modir']['title']);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
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