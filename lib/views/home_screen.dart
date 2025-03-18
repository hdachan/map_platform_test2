import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // kIsWeb를 사용하기 위해 추가
import 'package:untitled114/views/web/home_navermap_wevscreen.dart';
import '../../viewmodels/setting_viewmodel.dart';
import '../../utils/designSize.dart';
import 'home_main.dart'; // HomeMain1이 포함된 파일
import 'home_mypage.dart';
import 'home_navermap_screen.dart';
import 'web/home_web_main.dart';
import 'test.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();
  final GlobalKey<MYPageState> _myPageKey = GlobalKey<MYPageState>();

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context); // 디자인 사이즈 초기화
    return WillPopScope(
      onWillPop: () async {
        // 뒤로 가기를 막고 앱을 종료
        return false; // 뒤로 가기 방지
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
                          kIsWeb ? HomeMain2() : HomeMain1(),
                          const Center(child: Text("탭 4")),
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
                        BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: '코디'),
                        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
                        BottomNavigationBarItem(icon: Icon(Icons.live_tv_outlined), label: '라이브'),
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

  const KeepAlivePage({required this.child});

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