/*
사용 방법
ElevatedButton(
          onPressed: () => showEmptyBoxBottomSheet(context),
          child: const Text('빈 박스 팝업 열기'),
        ),
그냥 onPressed에 넣으면 됨
*/
import 'package:flutter/material.dart';

void showEmptyBoxBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SizedBox(
        height: 266,
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                '공유',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ), //상단 버튼
            Divider(
              color: Color(0xFFE7E7E7),
              thickness: 1, // 두께 0.1로 설정
              height: 1, // 높이 0.1로 설정
            ),
            Container(
              height: 108,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  buildIconTextButton(
                    imagePath: 'assets/image/QuickShare.png',
                    label: '나와의 채팅',
                    onPressed: () {
                      print("버튼1");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton(
                    imagePath: 'assets/image/QuickShare.png',
                    label: '정영원, 황대찬, 정주영, 강다은 그리고 누군가',
                    onPressed: () {
                      print("버튼2");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton(
                    imagePath: 'assets/image/QuickShare.png',
                    label: 'wndud3331@gmail.com',
                    onPressed: () {
                      print("버튼3");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton(
                    imagePath: 'assets/image/QuickShare.png',
                    label: '황대찬',
                    onPressed: () {
                      print("버튼4");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton(
                    imagePath: 'assets/image/QuickShare.png',
                    label: '강다은',
                    onPressed: () {
                      print("버튼5");
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xFFE7E7E7),
              thickness: 1, // 두께 0.1로 설정
              height: 1, // 높이 0.1로 설정
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  buildIconTextButton2(
                    imagePath: 'assets/image/QuickShare.png',
                    label: 'Quick Share',
                    onPressed: () {
                      print("버튼1");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton2(
                    imagePath: 'assets/image/QuickShare.png',
                    label: '카카오톡',
                    onPressed: () {
                      print("버튼2");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton2(
                    imagePath: 'assets/image/QuickShare.png',
                    label: 'Gmail',
                    onPressed: () {
                      print("버튼3");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton2(
                    imagePath: 'assets/image/QuickShare.png',
                    label: 'Instagram',
                    onPressed: () {
                      print("버튼4");
                    },
                  ),
                  SizedBox(width: 2),
                  buildIconTextButton2(
                    imagePath: 'assets/image/QuickShare.png',
                    label: 'Band',
                    onPressed: () {
                      print("버튼5");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildIconTextButton({
  required String imagePath,
  required String label,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: 64,
    height: 84,
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: 48,
            height: 48,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 28,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildIconTextButton2({
  required String imagePath,
  required String label,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: 64,
    height: 70,
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 48,
            height: 48,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 10,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          )
        ],
      ),
    ),
  );
}
