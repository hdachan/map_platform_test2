import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/data_viewmodel.dart';
import '../widgets/custom_bottomSheet.dart';
import 'custom_button.dart';

// StatelessWidget을 StatefulWidget으로 변경
class BottomSheetWidget extends StatefulWidget {
  final DraggableScrollableController sheetController;
  final Map<String, String?> filters;
  final Map<int, Future<List<String>>> imageFutures;
  final Function(double) onSheetExtentChanged;
  final Function(DataViewModel) onUpdateMarkers;
  final VoidCallback onFilterChanged; // 필터 변경 시 UI 갱신을 위한 콜백 추가

  const BottomSheetWidget({
    required this.sheetController,
    required this.filters,
    required this.imageFutures,
    required this.onSheetExtentChanged,
    required this.onUpdateMarkers,
    required this.onFilterChanged,
    super.key,
  });

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataViewModel>(context);

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        widget.onSheetExtentChanged(notification.extent);
        return true;
      },
      child: DraggableScrollableSheet(
        controller: widget.sheetController,
        initialChildSize: 0.2,
        minChildSize: 0.2,
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
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 152.h,
                    maxHeight: 152.h,
                    child: Column(
                      children: [
                        Container(
                          width: 360.w,
                          height: 24.h,
                          color: Color(0xFF1A1A1A),
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
                          height: 40.h,
                          color: Color(0xFF1A1A1A),
                          padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 231.w,
                                height: 20.h,
                                child: Text(
                                  '나에게 맞는 매장을 찾아봐요!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 1.10.h,
                                    letterSpacing: -0.45,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: () {
                                  FilterBottomSheet.show(context);
                                },
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: 89.w,
                                  height: 32.h,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFF888888)),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16.sp,
                                        color: Color(0xFF05FFF7),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '지역선택',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.30,
                                          letterSpacing: -0.30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 360.w,
                          height: 56.h,
                          color: Color(0xFF1A1A1A),
                          padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  BrandBottomSheet.show(context);
                                },
                                child: Container(
                                  width: 77.w,
                                  height: 32.h,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 31.w,
                                        height: 16.h,
                                        child: Text(
                                          '스타일',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.30,
                                            letterSpacing: -0.30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Container(
                                        width: 16.w,
                                        height: 16.h,
                                        child: Center(
                                          child: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: () async {
                                  final selectedGender = await GenderBottomSheet.show(context);
                                  widget.onFilterChanged(); // 필터 변경 시 UI 갱신
                                  widget.filters["gender"] = selectedGender;
                                  if (selectedGender != null || widget.filters["type"] != null) {
                                    await dataProvider.fetchFilteredDataInBounds(
                                      dataProvider.currentBounds!,
                                      widget.filters["gender"],
                                      widget.filters["type"],
                                    ).then((_) {
                                      widget.onUpdateMarkers(dataProvider);
                                    });
                                  } else {
                                    await dataProvider.fetchDataInBounds(dataProvider.currentBounds!).then((_) {
                                      widget.onUpdateMarkers(dataProvider);
                                    });
                                  }
                                },
                                child: Container(
                                  width: 67.w,
                                  height: 32.h,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 21.w,
                                        height: 16.h,
                                        child: Text(
                                          widget.filters["gender"] ?? '성별',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            // 필터가 적용된 경우(즉, widget.filters["gender"]가 null이 아닌 경우) 색깔 변경
                                            color: widget.filters["gender"] != null ? Color(0xFF05FFF7) : Colors.white,
                                            fontSize: 12.sp,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.30,
                                            letterSpacing: -0.30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Container(
                                        width: 16.w,
                                        height: 16.h,
                                        child: Center(
                                          child: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: () async {
                                  final selectedType = await StoreTypeBottomSheet.show(context);
                                  widget.onFilterChanged(); // 필터 변경 시 UI 갱신
                                  widget.filters["type"] = selectedType;
                                  if (selectedType != null || widget.filters["gender"] != null) {
                                    await dataProvider.fetchFilteredDataInBounds(
                                      dataProvider.currentBounds!,
                                      widget.filters["gender"],
                                      widget.filters["type"],
                                    ).then((_) {
                                      widget.onUpdateMarkers(dataProvider);
                                    });
                                  } else {
                                    await dataProvider.fetchDataInBounds(dataProvider.currentBounds!).then((_) {
                                      widget.onUpdateMarkers(dataProvider);
                                    });
                                  }
                                },
                                child: Container(
                                  width: 67.w,
                                  height: 32.h,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFF3D3D3D)),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 21.w,
                                        height: 16.h,
                                        child: Text(
                                          widget.filters["type"] ?? '매장',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: widget.filters["type"] != null ? Color(0xFF05FFF7) : Colors.white,
                                            fontSize: 12.sp,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.30,
                                            letterSpacing: -0.30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Container(
                                        width: 16.w,
                                        height: 16.h,
                                        child: Center(
                                          child: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 16.sp,
                                            color: Colors.white,
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
                        Container(
                          width: 360.w,
                          height: 32.h,
                          color: Color(0xFF1A1A1A),
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝으로 배치
                            children: [
                              Text(
                                '총 ${dataProvider.dataList.length} 개의 매장',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.30,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    // 1. 필터 데이터를 초기화
                                    widget.filters["gender"] = null; // 성별 필터 초기화
                                    widget.filters["type"] = null;   // 매장 타입 필터 초기화
                                    // 2. UI 갱신을 위한 콜백 호출
                                    widget.onFilterChanged(); // 필터 변경 시 UI 업데이트 트리거
                                  });

                                  // 3. 필터 없이 데이터 다시 불러오기
                                  dataProvider.fetchDataInBounds(dataProvider.currentBounds!).then((_) {
                                    // 4. 마커 업데이트
                                    widget.onUpdateMarkers(dataProvider);
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, // 불필요한 패딩 제거
                                  minimumSize: Size.zero,  // 최소 크기 제거
                                ),
                                child: Text(
                                  '필터 초기화',
                                  style: TextStyle(
                                    color: Color(0xFF05FFF7),
                                    fontSize: 12.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.30,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final modir = dataProvider.dataList[index];
                      if (!widget.imageFutures.containsKey(modir.id)) {
                        widget.imageFutures[modir.id] = fetchImagesForModir(modir.id);
                      }
                      return GestureDetector(
                        onTap: () {
                          widget.sheetController.animateTo(
                            0.2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          showMarkerBottomSheet(
                            context,
                            modir.address,
                            modir.roadAddress,
                            modir.type,
                            modir.title,
                            modir.latitude,
                            modir.longitude,
                            modir.id,
                            modir.trial,
                          );
                        },
                        child: Container(
                          width: 360.w,
                          height: 226.h,
                          decoration: ShapeDecoration(
                            color: Color(0xFF1A1A1A),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFF242424)),
                            ),
                          ),
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Column(
                            children: [
                              Container(
                                width: 360.w,
                                height: 18.h,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 18.h,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFFF6F6F6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(left: 4, right: 4, bottom: 2, top: 2),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 2.w),
                                          Container(
                                            height: 14.h,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.person_outline,
                                                  size: 12.sp,
                                                  color: Color(0xFF0B5C1F),
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  modir.clothesgender,
                                                  style: TextStyle(
                                                    color: Color(0xFF0B5C1F),
                                                    fontSize: 10.sp,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.40,
                                                    letterSpacing: -0.25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 360.w,
                                height: 20.h,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20.h,
                                      child: Text(
                                        modir.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          height: 1.40,
                                          letterSpacing: -0.35,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Container(
                                      width: 150.h,
                                      height: 16.h,
                                      child: Text(
                                        modir.type,
                                        style: TextStyle(
                                          color: Color(0xFF888888),
                                          fontSize: 12.sp,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          height: 1.30,
                                          letterSpacing: -0.30,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 20.h,
                                      height: 20.h,
                                      child: Center(
                                        child: Icon(
                                          Icons.favorite_outline,
                                          color: Colors.red,
                                          size: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 360.w,
                                height: 28.h,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  modir.description,
                                  style: TextStyle(
                                    color: Color(0xFFE7E7E7),
                                    fontSize: 10.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    height: 1.40,
                                    letterSpacing: -0.25,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 360.w,
                                height: 104.h,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: FutureBuilder<List<String>>(
                                  future: widget.imageFutures[modir.id],
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                            4,
                                                (_) => Container(
                                              width: 104.w,
                                              height: 104.h,
                                              margin: EdgeInsets.only(right: 8.w),
                                              color: Colors.grey[300],
                                              child: Center(child: CircularProgressIndicator()),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                            4,
                                                (_) => Container(
                                              width: 104.w,
                                              height: 104.h,
                                              margin: EdgeInsets.only(right: 8.w),
                                              color: Colors.grey,
                                              child: Center(child: Icon(Icons.error, color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      final imageUrls = snapshot.data!;
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: imageUrls.isNotEmpty
                                              ? imageUrls.take(4).map((url) {
                                            return Padding(
                                              padding: EdgeInsets.only(right: 8.w),
                                              child: CachedNetworkImage(
                                                imageUrl: url,
                                                width: 104.w,
                                                height: 104.h,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Container(
                                                  color: Colors.grey[300],
                                                  child: Center(child: CircularProgressIndicator()),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  color: Colors.grey,
                                                  child: Center(child: Icon(Icons.error, color: Colors.white)),
                                                ),
                                              ),
                                            );
                                          }).toList()
                                              : List.generate(
                                            4,
                                                (_) => Container(
                                              width: 104.w,
                                              height: 104.h,
                                              margin: EdgeInsets.only(right: 8.w),
                                              color: Colors.grey,
                                              child: Center(child: Icon(Icons.image_not_supported, color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: dataProvider.dataList.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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