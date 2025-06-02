import 'package:flutter/material.dart';

class CurationLogCard1 extends StatelessWidget {
  const CurationLogCard1({super.key});

  @override
  Widget build(BuildContext context) {
    return _CurationLogCardWrapper(
      title: '큐레이션 로그',
      subtitle: Row(
        children: const [
          Text('오늘', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('8', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('·', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('전체', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('12', style: _grayTextStyle),
        ],
      ),
      content: Row(
        children: const [
          Icon(Icons.monitor_heart_outlined, size: 12, color: Color(0xff888888)),
          SizedBox(width: 2),
          Text('저번 달과 비교해', style: _grayBoldTextStyle),
          SizedBox(width: 2),
          Text('18.7%', style: _blackBoldTextStyle),
          SizedBox(width: 2),
          Text('조회수가 떨어졌어요', style: _grayBoldTextStyle),
        ],
      ),
    );
  }
}

class CurationLogCard2 extends StatelessWidget {
  const CurationLogCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return _CurationLogCardWrapper(
      title: '큐레이션 분석',
      subtitle: Row(
        children: const [
          Text('주 연령', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('18', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('-', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('25', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('세', style: _grayTextStyle),
        ],
      ),
      content: Row(
        children: const [
          Icon(Icons.person_outline, size: 12, color: Color(0xff888888)),
          SizedBox(width: 2),
          Text('여성', style: _grayBoldTextStyle),
          SizedBox(width: 2),
          Text('85%', style: _blackBoldTextStyle),
          SizedBox(width: 2),
          Text('남성', style: _grayBoldTextStyle),
          SizedBox(width: 2),
          Text('15%', style: _grayBoldTextStyle),
        ],
      ),
    );
  }
}

class CurationLogCard3 extends StatelessWidget {
  const CurationLogCard3({super.key});

  @override
  Widget build(BuildContext context) {
    return _CurationLogCardWrapper(
      title: '내 큐레이션 키워드',
      subtitle: Row(
        children: const [
          Text('키워드', style: _grayTextStyle),
          SizedBox(width: 2),
          Text(':', style: _grayTextStyle),
          SizedBox(width: 2),
          Text('영화', style: _grayTextStyle),
        ],
      ),
      content: Row(
        children: const [
          Icon(Icons.search, size: 12, color: Color(0xff888888)),
          SizedBox(width: 2),
          Text('검색어', style: _grayBoldTextStyle),
          SizedBox(width: 2),
          Text('영화추천,', style: _blackBoldTextStyle),
          SizedBox(width: 2),
          Text('재밌는 영화,', style: _blackBoldTextStyle),
          SizedBox(width: 2),
          Text('혼자보기 좋은 영화', style: _blackBoldTextStyle),
        ],
      ),
    );
  }
}

/// 공통 Wrapper 위젯
class _CurationLogCardWrapper extends StatelessWidget {
  final String title;
  final Widget subtitle;
  final Widget content;

  const _CurationLogCardWrapper({
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              subtitle,
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}

/// 공통 텍스트 스타일
const _grayTextStyle = TextStyle(
  color: Color(0xff888888),
  fontFamily: 'Pretendard',
  fontSize: 10,
  fontWeight: FontWeight.w400,
  height: 1.2,
);

const _grayBoldTextStyle = TextStyle(
  color: Color(0xff888888),
  fontFamily: 'Pretendard',
  fontSize: 10,
  fontWeight: FontWeight.w500,
  height: 1.2,
);

const _blackBoldTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Pretendard',
  fontSize: 10,
  fontWeight: FontWeight.w500,
  height: 1.2,
);
