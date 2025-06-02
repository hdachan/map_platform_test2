import 'package:flutter/material.dart';
import 'share_bottom_sheet.dart';
import 'curation_card.dart';
import 'curation_log_carousel.dart';

bool isExpanded = false;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Test6(),
  ));
}

class Test6 extends StatefulWidget {
  const Test6({super.key});

  @override
  State<Test6> createState() => _Test6State();
}

class _Test6State extends State<Test6> {
  final List<String> categories = [
    '전체',
    '자유게시판',
    '카페',
    '전시',
    '음식점',
    '공원 산책로',
  ];

  String selectedCategory = '전체';
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "마이 큐레이션"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 202,
                        padding: EdgeInsets.only(
                            top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/bgimage.jpg'),
                            fit: BoxFit.fitWidth, // width 크기에 맞춰 이미지 크기 달라짐
                            //none 으로 하면 기존 이미지 크기에서 잘려서 나옴 / fill 으로 하면 크기 맞춰짐
                            colorFilter: ColorFilter.mode(
                              Color(0x66000000),
                              BlendMode.srcOver,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: -18,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('assets/image/cat.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 104,
                        right: 16,
                        bottom: 8,
                        child: Row(
                          children: [
                            Text(
                              '정주영',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                print("설정 버튼 클릭");
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xff403F3F),
                                ),
                                child: const Icon(
                                  Icons.settings,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showEmptyBoxBottomSheet(context);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xff403F3F),
                                ),
                                child: const Icon(
                                  Icons.ios_share,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(width: 88),
                            Text(
                              '큐레이션',
                              style: const TextStyle(
                                color: Color(0xff888888),
                                fontFamily: 'Pretendard',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '3개',
                              style: const TextStyle(
                                color: Color(0xff888888),
                                fontFamily: 'Pretendard',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '·',
                              style: const TextStyle(
                                color: Color(0xff888888),
                                fontFamily: 'Pretendard',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '좋아요',
                              style: const TextStyle(
                                color: Color(0xff888888),
                                fontFamily: 'Pretendard',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '36개',
                              style: const TextStyle(
                                color: Color(0xff888888),
                                fontFamily: 'Pretendard',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 260,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 214,
                                  child: Text(
                                    "MZ의 시각으로 영화와 드라마를 추천 및 소개합니다.\n내 취향에 딱 맞는영화 확인 하는 방법\n가나다라마바사아자차카타파하\n거너더러머버서어저처커터퍼허퍼러너너머ㅓㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇ",
                                    maxLines: isExpanded ? null : 4,
                                    overflow: isExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Pretendard',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 216,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      minimumSize: Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Text(
                                      isExpanded ? '접기' : '더 보기',
                                      style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff888888),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CurationLogCarousel(),
                  Container(
                    height: 52,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(categories.length, (index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;
        
                          return Padding(
                            padding: EdgeInsets.only(
                                right: index != categories.length - 1 ? 12 : 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                height: 28,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? Color(0xff3D3D3D)
                                        : Color(0xffE7E7E7),
                                  ),
                                  color: isSelected
                                      ? Color(0xff3D3D3D)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: isSelected
                                        ? Colors.white
                                        : Color(0xff888888),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        CurationCard(
                          imagePath: 'assets/image/cat.png',
                          title:
                              '말보다 더 깊게 스며드는 위로가 있다면,\n아마 그건 달콤함일 거예요 맛있는 디저트 카페',
                          description:
                              '“힘들었지? 고생 많았어.”\n누군가의 따뜻한 말 한마디가 위로가 되기도 하지만, 가끔은 입안 가득 퍼지는 달콤함이 더 깊고 부드럽게 마음을 어우만져줄 때가 있어요.',
                          likeCount: 12,
                          commentCount: 14,
                          viewCount: 16,
                          date: '2025.02.14',
                        ),
                        CurationCard(
                          imagePath: 'assets/image/cat.png',
                          title: '그지 같네',
                          description: '살려다오',
                          likeCount: 12,
                          commentCount: 14,
                          viewCount: 16,
                          date: '2025.02.14',
                        ),
                        CurationCard(
                          imagePath: 'assets/image/cat.png',
                          title: '그냥 쉽지 않음',
                          description: '아파양!!!',
                          likeCount: 12,
                          commentCount: 14,
                          viewCount: 16,
                          date: '2025.02.14',
                        ),
                        CurationCard(
                          imagePath: 'assets/image/cat.png',
                          title: '아 ㅋㅋ',
                          description: '개추좀',
                          likeCount: 12,
                          commentCount: 14,
                          viewCount: 16,
                          date: '2025.02.14',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

PreferredSizeWidget customAppBar(
  BuildContext context,
  String title,
) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(56),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),

                // more_vert 아이콘
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    print("more_vert 클릭");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
