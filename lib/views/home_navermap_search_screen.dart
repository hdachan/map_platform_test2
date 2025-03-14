import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';

import '../viewmodels/map_viewmodel.dart';



class search_screen extends StatefulWidget {
  @override
  _searchState_screen createState() => _searchState_screen();
}

class _searchState_screen extends State<search_screen> {
  bool _isLoading = false; // 로딩 상태를 나타내는 변수
  String _responseBody = "검색 결과가 여기에 표시됩니다."; // API 응답을 저장할 변수
  final TextEditingController _searchController = TextEditingController(); // 검색어 입력을 위한 컨트롤러
  Timer? _debounce; // 입력 지연을 위한 타이머
  static const int _minSearchLength = 2; // 최소 검색어 길이
  static const Duration _debounceDuration = Duration(milliseconds: 500); // 입력 지연 시간

  // API에서 데이터를 가져오는 비동기 함수
  Future<void> _fetchData(String query) async {
    if (query.length < _minSearchLength) return; // 최소 검색어 길이 미달 시 종료

    setState(() {
      _isLoading = true; // 로딩 시작
    });

    final String clientId = 'qDYgvkURUfWr3_ko1bvV'; // 네이버 개발자 센터에서 발급받은 Client ID
    final String clientSecret = '6RUet4giou'; // 네이버 개발자 센터에서 발급받은 Client Secret
    final String url =
        'https://openapi.naver.com/v1/search/local.json?query=$query&display=10&start=1&sort=sim'; // API 요청 URL

    try {
      // HTTP GET 요청
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        // 성공적으로 응답을 받았을 경우
        final Map<String, dynamic> data = json.decode(response.body); // JSON 응답 파싱
        final List<dynamic> items = data['items']; // 검색 결과 아이템 목록
        setState(() {
          // UI 업데이트
          _responseBody = items.map((item) {
            final title = item['title']; // 제목
            final document = html_parser.parse(title); // HTML 파싱
            final cleanTitle = document.body?.text ?? ''; // HTML 태그 제거
            final roadAddress = item['roadAddress'] ?? '도로명 주소 없음'; // 도로명 주소
            final address = item['address'] ?? '지번 주소 없음'; // 지번 주소

            final latitude = item['mapy']; // 위도
            final longitude = item['mapx']; // 경도
            final parsedLatitude = _parseCoordinate(latitude, isLatitude: true); // 위도 변환
            final parsedLongitude = _parseCoordinate(longitude, isLatitude: false); // 경도 변환

            // 결과 문자열 생성
            return '$cleanTitle|$parsedLatitude|$parsedLongitude';
            //return '$cleanTitle\n도로명: $roadAddress\n지번: $address\n위도: $parsedLatitude, 경도: $parsedLongitude\n';
          }).join('\n');
        });
      } else {
        // 응답 실패 시
        setState(() {
          _responseBody = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      // 예외 발생 시
      setState(() {
        _responseBody = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // 로딩 종료
      });
    }
  }

  // 좌표를 소수점 형태로 변환하는 함수
  String _parseCoordinate(String coordinate, {required bool isLatitude}) {
    if (coordinate.isEmpty) return '0.0'; // 빈 문자열 처리
    final integerLength = isLatitude ? 2 : 3; // 위도와 경도에 따라 정수 부분 길이 결정
    final integerPart = coordinate.substring(0, integerLength); // 정수 부분
    final decimalPart = coordinate.substring(integerLength); // 소수 부분
    return '$integerPart.$decimalPart'; // 소수점 형태로 반환
  }

  // 검색어가 변경될 때 호출되는 함수
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel(); // 기존 타이머 취소
    _debounce = Timer(_debounceDuration, () {
      if (_searchController.text.length >= _minSearchLength) {
        _fetchData(_searchController.text); // 검색어가 최소 길이를 만족하면 데이터 가져오기
      }
    });
  }

  void moveToSearchLocation(BuildContext context, double lat, double lng) {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    mapProvider.moveToLocation(lat, lng); // ✅ 지도 이동
    Navigator.pop(context); // 검색창 닫기
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged); // 검색어 변경 리스너 추가
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged); // 리스너 제거
    _searchController.dispose(); // 컨트롤러 해제
    _debounce?.cancel(); // 타이머 해제
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onTap: () {
                      Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아감
                    },
                    child: Container(
                      width: 56.w,
                      height: 56.h,
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.chevron_left,
                        size: 24.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 288.w,
                    height: 36.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFF3D3D3D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    padding: EdgeInsets.only(left: 8.w, right: 16.w, top: 8.h, bottom: 8.h),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '매장, 위치 검색',
                        hintStyle: TextStyle(
                          color: Color(0xFF888888),
                        ),
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
                ],
              ),
            ),

            Container(
              width: 360.w,
              height: 52.h,
              padding: EdgeInsets.only(left: 16,right: 16,top: 24),
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


            // 검색 결과 표시 영역
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: _responseBody.split('\n').map((result) {
                        List<String> parts = result.split('|');
                        if (parts.length < 3) return Container(); // 데이터 부족 시 무시

                        String title = parts[0].trim();
                        double latitude = double.tryParse(parts[1]) ?? 0.0;
                        double longitude = double.tryParse(parts[2]) ?? 0.0;

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(360.w, 48.h),
                            backgroundColor: Color(0xFF1A1A1A),
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            print("이동할 위치: $latitude, $longitude"); // 디버깅용 로그

                            final mapProvider = Provider.of<MapProvider>(context, listen: false);
                            mapProvider.moveToLocation(latitude, longitude); // 지도 이동
                            Navigator.pop(context); // 검색창 닫기 (선택 사항)
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

                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
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
          ],
        ),
      ),
    );
  }
}
