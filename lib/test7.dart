import 'package:flutter/material.dart';
import 'share_bottom_sheet.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TagPopupExample(),
  ));
}

class TagPopupExample extends StatelessWidget  {
  const TagPopupExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('빈 박스 팝업 예제'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showEmptyBoxBottomSheet(context),
          child: const Text('빈 박스 팝업 열기'),
        ),
      ),
    );
  }
}