import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test/feed.dart';

class FeedRepository {
  final String baseUrl = "http://localhost:8080/api/feed";
  final String uuid = "123"; // 임시 사용자 ID

  /// 전체 게시글 조회
  Future<List<Feed>> fetchFeeds() async {
    final response = await http.get(Uri.parse("$baseUrl?uuid=$uuid"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)["resultData"];
      return data.map((json) => Feed.fromJson(json)).toList();
    } else {
      throw Exception("서버 오류: ${response.statusCode}");
    }
  }

  /// 게시글 등록
  Future<void> postFeed(String title, String content) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "content": content, "uuid": uuid}),
    );
    if (response.statusCode != 200) {
      throw Exception("게시글 등록 실패");
    }
  }

  /// 게시글 수정
  Future<void> updateFeed(int feedId, String title, String content) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"feedId": feedId, "title": title, "content": content}),
    );
    if (response.statusCode != 200) {
      throw Exception("수정 실패");
    }
  }

  /// 게시글 삭제 (숨김 처리)
  Future<void> deleteFeed(int feedId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/delete"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(feedId),
    );
    if (response.statusCode != 200) {
      throw Exception("삭제 실패");
    }
  }

  /// 게시글 상세 조회
  Future<FeedDetail> fetchFeedDetail(int feedId) async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/feed/detail?feedId=$feedId&uuid=$uuid"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["resultData"];
      return FeedDetail.fromJson(data);
    } else {
      throw Exception("상세 조회 실패");
    }
  }


  /// 좋아요 토글
  Future<void> toggleLike(int feedId) async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/api/like?feedId=$feedId&uuid=$uuid"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["resultData"] == 1) {
        return; // 성공
      } else {
        throw Exception("좋아요 토글 실패: 예상치 못한 응답");
      }
    } else {
      throw Exception("좋아요 실패: ${response.statusCode}");
    }
  }
}
