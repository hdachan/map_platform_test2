import 'dart:io'; // exit(0) 사용을 위해 추가
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemNavigator.pop() 사용을 위해 추가
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:untitled114/views/web/home_navermap_wevscreen.dart';
import '../../viewmodels/setting_viewmodel.dart';
import '../../utils/designSize.dart';
import 'home_mypage.dart';
import 'home_navermap_screen.dart';
import 'test.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // super.key 적용

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<MYPageState> _myPageKey = GlobalKey<MYPageState>();

  DateTime? _lastBackPressed; // 이제 StatefulWidget이므로 변경 가능

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context);
    return PopScope(
      canPop: false, // 뒤로 가기 기본 차단
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final now = DateTime.now();
          if (_lastBackPressed == null ||
              now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
            _lastBackPressed = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("한 번 더 누르면 앱이 종료됩니다.")),
            );
          } else {
            // 앱 완전 종료 (안드로이드/iOS 대응)
            if (Platform.isAndroid) {
              SystemNavigator.pop(); // 안드로이드에서 앱 종료
            } else if (Platform.isIOS) {
              exit(0); // iOS에서도 강제 종료
            }
          }
        }
      },
      child: Consumer<SettingState>(
        builder: (context, settingState, child) {
          return Scaffold(
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          settingState.updateIndex(index);
                          if (index != 4) {
                            _myPageKey.currentState?.removeOverlay();
                          }
                        },
                        children: [
                          kIsWeb ? WebMapScreen() : MapScreen(),
                          MYPage(key: _myPageKey),
                          mmmm(),
                        ],
                      ),
                    ),
                    BottomNavigationBar(
                      currentIndex: settingState.selectedIndex,
                      onTap: (index) {
                        settingState.updateIndex(index);
                        _pageController.jumpToPage(index);
                        if (index != 4) {
                          _myPageKey.currentState?.removeOverlay();
                        }
                      },
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: const Color(0xFF1A1A1A),
                      selectedItemColor: const Color(0xFF05FFF7),
                      unselectedItemColor: Colors.grey,
                      items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: '지도'),
                        BottomNavigationBarItem(icon: Icon(Icons.checkroom_outlined), label: '추천'),
                        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}





// 하단바 관리 툴_KeepAlive를 위한 래퍼 위젯 (사용시 메모리에 계속 유지)
class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({super.key, required this.child});

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 메모리에 유지

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 필수
    return widget.child;
  }
}