import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: FeedApp()));
}

class FeedApp extends StatefulWidget {
  @override
  _FeedAppState createState() => _FeedAppState();
}

class _FeedAppState extends State<FeedApp> {
  List feeds = [];
  String? message;
  bool isLoading = true;

  final String baseUrl = "http://localhost:8080/api/feed"; // ⚠ 실제 IP로 교체

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> fetchFeeds() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          feeds = data["resultData"];
          message = data["resultMessage"];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = "에러 발생: $e";
        isLoading = false;
      });
    }
  }

  Future<void> postFeed() async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": titleController.text,
        "content": contentController.text,
        "uuid": "123" // 테스트용 UUID
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("게시글 등록 완료")));
      await fetchFeeds();
    }
  }

  Future<void> updateFeed(int feedId) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "feedId": feedId,
        "title": titleController.text,
        "content": contentController.text,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("수정 완료")));
      await fetchFeeds();
    }
  }

  Future<void> deleteFeed(int feedId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/delete"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(feedId),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("삭제 완료")));
      await fetchFeeds();
    }
  }

  void showFeedDialog({int? feedId}) {
    if (feedId != null) {
      final existing = feeds.firstWhere((f) => f["feedId"] == feedId);
      titleController.text = existing["title"];
      contentController.text = existing["content"];
    } else {
      titleController.clear();
      contentController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(feedId == null ? "게시글 작성" : "게시글 수정"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "제목")),
            TextField(controller: contentController, decoration: InputDecoration(labelText: "내용")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("취소"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (feedId == null) {
                await postFeed();
              } else {
                await updateFeed(feedId);
              }
            },
            child: Text(feedId == null ? "등록" : "수정"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("피드 리스트"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchFeeds,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : feeds.isEmpty
          ? Center(child: Text("피드 없음"))
          : ListView.builder(
        itemCount: feeds.length,
        itemBuilder: (context, index) {
          final feed = feeds[index];
          return ListTile(
            title: Text(feed["title"]),
            subtitle: Text(feed["content"]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => showFeedDialog(feedId: feed["feedId"])),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteFeed(feed["feedId"])),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFeedDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
