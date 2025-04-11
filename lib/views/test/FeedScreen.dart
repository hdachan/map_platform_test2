import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/test/feed.dart';
import '../../viewmodels/test/FeedViewModel.dart';
import 'FeedDetailScreen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    final feedVM = Provider.of<FeedViewModel>(context, listen: false);
    feedVM.fetchFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("피드")),
      body: Consumer<FeedViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: viewModel.feeds.length,
            itemBuilder: (context, index) {
              Feed feed = viewModel.feeds[index];
              return ListTile(
                title: Text(feed.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feed.content),
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.grey, size: 20),
                        const SizedBox(width: 4),
                        Text('${feed.likeCount}명이 좋아요'), // 좋아요 갯수만 표시
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FeedDetailScreen(feedId: feed.feedId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}