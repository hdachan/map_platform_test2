import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/test/FeedViewModel.dart';

class FeedDetailScreen extends StatefulWidget {
  final int feedId;

  const FeedDetailScreen({super.key, required this.feedId});

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<FeedViewModel>(context, listen: false);
    viewModel.loadFeedDetail(widget.feedId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("게시글 상세")),
      body: Consumer<FeedViewModel>(
        builder: (context, viewModel, _) {
          final feed = viewModel.selectedFeed;

          if (feed == null || viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feed.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(feed.content),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        feed.liked ? Icons.favorite : Icons.favorite_border,
                        color: feed.liked ? Colors.red : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        viewModel.toggleLike(widget.feedId); // 좋아요 토글
                      },
                    ),
                    const SizedBox(width: 8),
                    Text("${feed.sumLike}명이 좋아합니다"),
                  ],
                ),
                const SizedBox(height: 16),
                Text("작성자: ${feed.username}"),
                Text("조회수: ${feed.hits}"),
                Text("작성일: ${feed.createdAt}"),
              ],
            ),
          );
        },
      ),
    );
  }
}