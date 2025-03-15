import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? message;
  bool isLoading = true; // 로딩 상태 추가

  Future<void> fetchData() async {
    final url = Uri.parse("http://192.168.45.12:8080/api/hello"); // 같은 Wi-Fi 환경이면 PC의 로컬 IP 사용


    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          message = data["message"];
          isLoading = false;
        });
      } else {
        setState(() {
          message = "Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = "⚠ 서버 연결 실패: $e";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter & Spring Boot")),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator() // 로딩 중이면 스피너 표시
              : Text(
            message ?? "No data",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
