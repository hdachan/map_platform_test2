// lib/views/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: SafeArea(
          child: Column(
            children: [
              // 검색 바
              Container(
                width: 360.w,
                height: 56.h,
                padding: EdgeInsets.only(right: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 56.w,
                        height: 56.h,
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.chevron_left, size: 24.sp, color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 288.w,
                      height: 36.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFF3D3D3D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      child: Consumer<SearchViewModel>(
                        builder: (context, viewModel, child) => TextField(
                          controller: _searchController,
                          onChanged: viewModel.onSearchChanged,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '매장, 위치 검색',
                            hintStyle: TextStyle(color: Color(0xFF888888)),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.40.h,
                            letterSpacing: -0.35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 360.w,
                height: 52.h,
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h),
                child: Text(
                  '매장 · 지역 인기 검색어',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.40.h,
                    letterSpacing: -0.35,
                  ),
                ),
              ),

              // 검색 결과
              Expanded(
                child: Consumer<SearchViewModel>(
                  builder: (context, viewModel, child) => Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: viewModel.searchResults.map((result) {
                            final title = result['title'] ?? '';
                            final latitude = double.tryParse(result['latitude'] ?? '0.0') ?? 0.0;
                            final longitude = double.tryParse(result['longitude'] ?? '0.0') ?? 0.0;

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(360.w, 48.h),
                                backgroundColor: Color(0xFF1A1A1A),
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              ),
                              onPressed: () {
                                viewModel.moveToLocation(context, latitude, longitude);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.search, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          height: 1.40.h,
                                          letterSpacing: -0.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.north_west, color: Colors.white),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if (viewModel.isLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5), // withOpacity 대신 withValues 사용
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}