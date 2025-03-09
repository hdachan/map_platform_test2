import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WebMapScreen(),
        );
      },
    );
  }
}

class WebMapScreen extends StatefulWidget {
  @override
  _WebMapScreenState createState() => _WebMapScreenState();
}

class _WebMapScreenState extends State<WebMapScreen> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  double _dragStartHeight = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<double>(begin: 0, end: 324.h).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _showCustomOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeOverlayWithAnimation,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {},
                onVerticalDragStart: (details) {
                  _dragStartHeight = _heightAnimation.value;
                },
                onVerticalDragUpdate: (details) {
                  double newHeight = _dragStartHeight - details.delta.dy;
                  newHeight = newHeight.clamp(0, 324.h);
                  _animationController.value = newHeight / 324.h;
                },
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! > 500) {
                    // 빠르게 아래로 스와이프 -> 빨간색까지
                    _closeOverlayWithAnimation();
                  } else if (details.primaryVelocity! < -500) {
                    // 빠르게 위로 스와이프 -> 완전히 열기
                    _animationController.forward();
                  } else {
                    // 천천히 내릴 때 -> 빨간색까지
                    _closeOverlayWithAnimation();
                  }
                },
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedBuilder(
                    animation: _heightAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 360.w,
                        height: _heightAnimation.value,
                        child: Column(
                          children: [
                            Container(
                              width: 360.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.w),
                                  topRight: Radius.circular(25.w),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                              child: Center(
                                child: Container(
                                  width: 48.w,
                                  height: 4.h,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: 360.w,
                              height: 56.h,
                              color: Colors.red,
                            ),
                            if (_heightAnimation.value > 96.h)
                              Container(
                                width: 360.w,
                                height: 32.h,
                                color: Colors.yellow,
                              ),
                            if (_heightAnimation.value > 128.h)
                              Container(
                                width: 360.w,
                                height: 128.h,
                                color: Colors.cyanAccent,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward(from: 0);
  }

  void _closeOverlayWithAnimation() {
    if (_overlayEntry != null) {
      if (_animationController.value > 96.h / 324.h) {
        _animationController.animateTo(96.h / 324.h);
      } else {
        _animationController.reverse().then((_) => _removeOverlay());
      }
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.reset();
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showCustomOverlay,
                    child: Container(
                      width: 150.w,
                      height: 150.h,
                      color: Colors.cyan,
                      child: const Center(
                        child: Text(
                          '오버레이 열기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      print("뒤 화면 버튼 클릭됨!");
                      _closeOverlayWithAnimation();
                    },
                    child: const Text("뒤 화면 버튼"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}