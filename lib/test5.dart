import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Test5(),
    debugShowCheckedModeBanner: false,
  ));
}

class Test5 extends StatefulWidget {
  const Test5({super.key});

  @override
  State<Test5> createState() => _Test5State();
}

class _Test5State extends State<Test5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        "탈퇴하기",
        const Color(0xFFFFFFFF),
        () => print('Complete Pressed'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: const ChatBox(),
        ),
      ),
      backgroundColor: const Color(0XFFE7E7E7),
    );
  }
}

//상단 바 위젯
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
              GestureDetector(
                onTap: () => print("뒤로가기"),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
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
              GestureDetector(
                onTap: () => print("메뉴"),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.more_vert,
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

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final List<Map<String, dynamic>> messages = [
    {'text': '안녕하세요!', 'isMine': false},
    {'text': '어떻게 도와드릴까요?', 'isMine': false},
    {'text': '회원 탈퇴하려고요.', 'isMine': true},
    {'text': '네, 안내해드릴게요.', 'isMine': false},
    {
      'type': 'images',
      'images': ['assets/image/cat.png', 'assets/image/cat.png', 'assets/image/cat.png'],
      'isMine': false
    },
  ];


  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool showHintBox = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        showHintBox = _controller.text.contains('/');
      });
    });
  }

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'text': text, 'isMine': true});
      _controller.clear();
      showHintBox = false; // 입력 후 힌트 박스 닫기
    });

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Color(0XFFE7E7E7),
            padding: const EdgeInsets.only(top: 24, left: 14, right: 14, bottom: 12),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isFirstOfPartner =
                    !msg['isMine'] && (index == 0 || messages[index - 1]['isMine']);

                return Align(
                  alignment: msg['isMine'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: msg['isMine']
                      ? _buildMyMessage(msg['text'])
                      : _buildPartnerMessage(msg['text'], isFirstOfPartner),
                );

              },
            ),
          ),
        ),

        if (showHintBox) // 힌트 박스 표시
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              '큐레이션 명령어를 사용할 수 있어요!',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    decoration: const InputDecoration(
                      hintText: '/를 통해 큐레이션 리스트를 확인하세요',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      filled: true,
                      fillColor: Color(0XFFE7E7E7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: Color(0XFFE7E7E7),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Color(0xff888888)),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


//모디 채팅 UX 위젯
Widget _buildPartnerMessage(dynamic content, bool isFirst) {
  String? text;
  bool isImage = false;
  bool isImageList = false;
  String? singleImagePath;
  List<String>? imagePaths;

  // 메시지가 텍스트인지, 이미지인지, 이미지 리스트인지 구분
  if (content is Map<String, dynamic>) {
    if (content['type'] == 'image' && content['image'] != null) {
      isImage = true;
      singleImagePath = content['image'];
    } else if (content['type'] == 'images' && content['images'] != null) {
      isImageList = true;
      imagePaths = List<String>.from(content['images']);
    }
  } else if (content is String) {
    text = content;
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (isFirst)
        Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: const Color(0xffC4C4C4),
            borderRadius: BorderRadius.circular(4),
          ),
        )
      else
        const SizedBox(width: 44),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFirst)
            const Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Text(
                '모디',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: (isImage || isImageList)
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: isImage
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                singleImagePath!,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            )
                : isImageList
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: imagePaths!
                    .map((path) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      path,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
                    .toList(),
              ),
            )
                : Text(
              text ?? '',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}



//사용자 채팅 UX 위젯
Widget _buildMyMessage(String text) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 2),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xff3D3D3D),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.zero,
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );
}
