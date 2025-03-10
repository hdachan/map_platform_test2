import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DraggableScrollableSheet Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sheetExtent = 0.2; // 초기 바텀시트 크기

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // 바텀시트 상단 위치 계산
    double sheetTop = screenHeight * (1 - _sheetExtent);
    double buttonTop = sheetTop - 95; // 버튼을 시트 바로 위에 배치

    return Scaffold(
      appBar: AppBar(
        title: Text('DraggableScrollableSheet Example'),
      ),
      body: Stack(
        children: [
          // 배경 콘텐츠
          Center(
            child: Text(
              '메인 콘텐츠',
              style: TextStyle(fontSize: 24),
            ),
          ),
          // DraggableScrollableSheet (현재 크기를 감지하여 버튼 이동)
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetExtent = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.1,
              maxChildSize: 1.0,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      // ✅ 필터 영역 (고정되지만 DraggableScrollableSheet 드래그에 반응)
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: _SliverAppBarDelegate(
                          minHeight: 60,
                          maxHeight: 60,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "필터 옵션",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // 필터 버튼 동작
                                  },
                                  child: Text("필터 적용"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ✅ 리스트 영역 (DraggableScrollableSheet과 함께 스크롤됨)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return Container(
                              width: 360,
                              height: 168,
                              child: Column(
                                children: [
                                  Container(
                                    width: 360,
                                    height: 128,
                                    color: Colors.cyan,
                                    padding: EdgeInsets.all(12),
                                    child: Container(
                                      width: 328,
                                      height: 108,
                                      color: Colors.cyanAccent,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 212,
                                            height: 68,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            width: 108,
                                            height: 108,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 360,
                                    height: 40,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 움직이는 버튼 (DraggableScrollableSheet 위쪽에 위치)
          Positioned(
            top: buttonTop,
            left: MediaQuery.of(context).size.width / 2 - 50, // 중앙 정렬
            child: ElevatedButton(
              onPressed: () {
                // 버튼 클릭 시 실행할 동작
              },
              child: Text('이동 버튼'),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ SliverPersistentHeader용 delegate 클래스 (오류 해결)
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
