import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Test1(),
  ));
}

class Test1 extends StatefulWidget {
  const Test1({super.key});

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isContentEmpty = true;
  Color _completeButtonColor = const Color(0xFF888888);

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_textFieldListener);
    _contentController.addListener(_textFieldListener);
  }

  void _textFieldListener() {
    setState(() {
      _isContentEmpty = _contentController.text.trim().isEmpty;
      _completeButtonColor = (_titleController.text.trim().isNotEmpty &&
          _contentController.text.trim().isNotEmpty)
          ? Colors.black
          : const Color(0xFF888888);
    });
  }

  void _onCompletePressed() {
    final String titleText = _titleController.text.trim();
    final String contentText = _contentController.text.trim();

    if (titleText.isNotEmpty && contentText.isNotEmpty) {
      print('텍스트 있음');
    } else {
      print('텍스트 없음');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          context, "글쓰기", _completeButtonColor, _onCompletePressed),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                            ),
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return Container(
                                width: 600,
                                height: 240,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 48,
                                      padding:
                                      EdgeInsets.only(top: 16, bottom: 12),
                                      color: Colors.white,
                                      child: Text('너의 감정을 알려줘',
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              height: 1.4)),
                                    ),
                                    Container(
                                        height: 72,
                                        padding:
                                        EdgeInsets.only(top: 4, bottom: 4),
                                        color: Colors.white,
                                        child: SelectableTagList(
                                          tags: [
                                            '기쁨',
                                            '우울함',
                                            '쓸쓸함',
                                            '고독함',
                                            '신남',
                                            '화남',
                                            '외로움',
                                            '자유게시판',
                                            '자유게시판'
                                          ],
                                          onChanged: (selected) {
                                            print('현재 선택: $selected');
                                          },
                                        )),
                                    Container(
                                      height: 48,
                                      padding:
                                      EdgeInsets.only(top: 16, bottom: 12),
                                      color: Colors.white,
                                      child: Text('테마 별로 글을 써보자',
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              height: 1.4)),
                                    ),
                                    Container(
                                        height: 72,
                                        padding:
                                        EdgeInsets.only(top: 4, bottom: 4),
                                        color: Colors.white,
                                        child: SelectableTagList(
                                          tags: [
                                            '카페',
                                            '전시',
                                            '쓸쓸함',
                                            '고독함',
                                            '신남',
                                            '화남',
                                            '외로움',
                                            '자유게시판',
                                            '자유게시판'
                                          ],
                                          onChanged: (selected) {
                                            print('현재 선택: $selected');
                                          },
                                        ))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          child: Row(
                            children: [
                              Text(
                                "게시글의 주제를 선택해주세요",
                                style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    height: 1.3),
                              ),
                              Container(
                                width: 16,
                                height: 16,
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  //arrow_under_ios_new 아이콘이 없음 있으면 넣어주쇼
                                  color: Colors.black,
                                  size: 14, // 위 아이콘 없어서 크기 조절 12->14
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 56,
                  child: TextField(
                    controller: _titleController,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: "제목을 입력해주세요",
                      hintStyle: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF888888),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFF888888), width: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _contentController,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          hintText: "내용을 입력해주세요",
                          hintStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF888888),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 10),
                        ),
                      ),
                      if (_isContentEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            '본 게시판의 사용 목적은 패션을 주제로 한 커뮤니티입니다.\n'
                                '사용 목적이 옳바르지 않은 글을 게시하거나 시도한다면 서비스 사용이\n'
                                '영구 제한 될 수도 있습니다.\n\n'
                                '아래에는 이 게시판에 해당되는 핵심 내용에 대한 요약사항이며, 게시물 작성전 커뮤니티\n'
                                '이용규칙 전문을 반드시 확인하시길 바랍니다.\n\n'
                                '게시판에서 미리보기로 확인 가능한 텍스트는 첫 줄에 해당되는 텍스트입니다.\n'
                                '게시판에서 미리보기로 확인 가능한 이미지는 처음 올리는 이미지 한 장입니다.\n\n'
                                '• 정치·사회 관련 행위 금지\n'
                                '• 홍보 및 판매 관련 행위 금지\n'
                                '• 불법촬영물 유통 금지\n'
                                '• 타인의 권리를 침해하거나 불쾌감을 주는 행위\n'
                                '• 범죄, 불법 행위 등 법령을 위반하는 행위\n'
                                '• 욕설, 비하, 차별, 혐오, 자살, 폭력 관련 내용 금지\n'
                                '• 음란물, 성적, 수치심 유발 금지\n'
                                '• 스포일러, 공포, 속임, 놀람 유도 금지',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(),
      backgroundColor: Colors.white,
    );
  }
}

PreferredSizeWidget customAppBar(
    BuildContext context,
    String title,
    Color completeButtonColor,
    VoidCallback onCompletePressed,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 뒤로가기
              GestureDetector(
                onTap: () => print("뒤로가기"),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),

              // 가운데 타이틀
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

              // 완료 버튼
              GestureDetector(
                onTap: onCompletePressed,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "완료",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: completeButtonColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget bottomBar() {
  return Container(
    height: 56,
    color: Colors.white,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFF888888), width: 0.1),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => print("이미지"),
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => print("카메라"),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => print("투표"),
                  child: Icon(
                    Icons.how_to_vote_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// 여기서부터 카테고리 부분
class SelectableTagList extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) onChanged;

  const SelectableTagList({
    super.key,
    required this.tags,
    required this.onChanged,
  });

  @override
  State<SelectableTagList> createState() => _SelectableTagListState();
}

class _SelectableTagListState extends State<SelectableTagList> {
  List<String> selectedTags = [];

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        if (selectedTags.length < 3) {
          selectedTags.add(tag);
        }
      }
    });
    widget.onChanged(selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.tags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => toggleTag(tag),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.black : Color(0xff888888),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
