import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/cutstom_appbar.dart';
import 'filter_provider.dart';


class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> selectedFilters = []; // 선택된 필터 목록

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 탭 개수 설정
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 필터를 토글(선택/해제)하는 메서드
  void toggleFilter(String filter) {
    setState(() {
      if (selectedFilters.contains(filter)) {
        selectedFilters.remove(filter);
      } else {
        selectedFilters.add(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                buildHeaderBar(
                  context,
                  filterText: '필터', // 원하는 필터 텍스트
                  resetText: '초기화', // 원하는 초기화 텍스트
                ),

                // 필터 넣은 목록 영역 (선택된 필터들을 Chip 등으로 표시)
                filterProvider.selectedFilters.isEmpty
                    ? SizedBox.shrink()
                    : Container(
                  width: 360.w,
                  height: 44.h,
                  color: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                      filterProvider.selectedFilters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Chip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              // 원하는 둥글기 값
                              side: BorderSide(color: Colors.transparent),
                            ),
                            label: Text(filter),
                            backgroundColor: Color(0xFF3D3D3D),
                            labelStyle:
                            const TextStyle(color: Colors.white),
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                            onDeleted: () {
                              filterProvider.toggleFilter(filter);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // 탭바 디자인
                Container(
                  width: 360.w,
                  height: 54.h,
                  color: const Color(0xFF1A1A1A),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: const Color(0xFF05FFF7),
                    // 선택된 탭의 색상
                    unselectedLabelColor: const Color(0xFFB0B0B0),
                    indicatorColor: const Color(0xFF05FFF7),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: const EdgeInsets.only(top: 16, bottom: 0),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    tabs: const [
                      Tab(
                          child: Text('스타일',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.40,
                                  letterSpacing: -0.50))),
                      Tab(
                          child: Text('브랜드',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.40,
                                  letterSpacing: -0.50))),
                    ],
                  ),
                ),

                // 탭바 정보
                Container(
                  height: 300.h, // 탭바 컨텐츠 높이
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      StyleScreen(
                        selectedFilters: selectedFilters,
                        onFilterToggle: toggleFilter,
                      ),
                      BrandScreen(), // 브랜드 화면은 필요에 따라 구현
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 스타일 탭 화면 (필터 버튼들을 보여줌)
class StyleScreen extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;

  const StyleScreen(
      {Key? key, required this.selectedFilters, required this.onFilterToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 버튼들을 Row에 배치
    final filterProvider = Provider.of<FilterProvider>(context);
    return Container(
      width: 360.w,
      height: 570.h,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => filterProvider.toggleFilter("캐주얼"),
                child: casualButton("캐주얼",
                    isSelected: filterProvider.selectedFilters.contains("캐주얼")),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () => filterProvider.toggleFilter("빈티지"),
                child: casualButton("빈티지",
                    isSelected: filterProvider.selectedFilters.contains("빈티지")),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              GestureDetector(
                onTap: () => filterProvider.toggleFilter("스포티"),
                child: casualButton("스포티",
                    isSelected: filterProvider.selectedFilters.contains("스포티")),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              GestureDetector(
                onTap: () => filterProvider.toggleFilter("아메카지"),
                child: casualButton("아메카지",
                    isSelected:
                    filterProvider.selectedFilters.contains("아메카지")),
              ),
              SizedBox(width: 16.w),
            ],
          ),
        ],
      ),
    );
  }
}

/// 브랜드 탭 화면 (필요에 따라 구현)
class BrandScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 570.h,
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 360.w,
            height: 48.h,
            padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
            child: Container(
              width: 328.w,
              height: 36.h,
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
              decoration: ShapeDecoration(
                color: Color(0xFF3D3D3D),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '찾는 브랜드를 검색 해주세요',
                    hintStyle: TextStyle(color: Color(0xFF888888)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 필터 버튼 위젯 (선택 상태에 따라 스타일 변경)
Widget casualButton(String text, {bool isSelected = false}) {
  return Container(
    width: 68.w,
    height: 36.h,
    decoration: ShapeDecoration(
      color: isSelected
          ? const Color(0xFF05FFF7).withOpacity(0.2)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: isSelected ? const Color(0xFF05FFF7) : const Color(0xFF3D3D3D),
        ),
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.40,
          letterSpacing: -0.35,
        ),
      ),
    ),
  );
}
