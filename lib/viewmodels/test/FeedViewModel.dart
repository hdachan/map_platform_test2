import 'package:flutter/material.dart';
import '../../models/test/feed.dart';
import '../../services/FeedService.dart';

class FeedViewModel extends ChangeNotifier {
  final FeedRepository repository;

  List<Feed> _feeds = [];
  List<Feed> get feeds => _feeds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FeedDetail? selectedFeed;

  FeedViewModel(this.repository);

  Future<void> fetchFeeds() async {
    _isLoading = true;
    notifyListeners();

    try {
      _feeds = await repository.fetchFeeds();
    } catch (e) {
      print("Error fetching feeds: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFeedDetail(int feedId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("🟡 상세 불러오기 시작");
      selectedFeed = await repository.fetchFeedDetail(feedId);
      print("🟢 상세 불러오기 성공: ${selectedFeed?.title}");
    } catch (e) {
      print("🔴 상세 불러오기 실패: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(int feedId) async {
    try {
      // 좋아요 토글 API 호출
      await repository.toggleLike(feedId);

      // 최신 데이터 가져오기
      if (selectedFeed != null && selectedFeed!.title.isNotEmpty) {
        // 디테일 화면이 열려있는 경우, 최신 디테일 데이터 다시 가져오기
        selectedFeed = await repository.fetchFeedDetail(feedId);
      }

      // 리스트 데이터도 갱신
      _feeds = await repository.fetchFeeds();

      notifyListeners();
    } catch (e) {
      print("좋아요 토글 실패: $e");
    }
  }
}