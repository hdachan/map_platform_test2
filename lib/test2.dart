import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Test2()));
}

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test1State();
}

class _Test1State extends State<Test2> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {}); // 입력값 변경 시 UI 갱신
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _emailController.text.isNotEmpty;

    return Scaffold(
      appBar: customAppBar(
        context,
        "모디랑 회원가입",
        const Color(0xFFFFFFFF),
        () => print('Complete Pressed'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 148,
                  color: const Color(0xFF1A1A1A),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "이메일 입력",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "로그인에 사용할 이메일을 입력해주세요",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFFFFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: const Color(0xFF1A1A1A),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "이메일을 입력해주세요",
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: Color(0xFFFFFFFF),
                            fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: "email@address.com",
                            hintStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                color: Color(0xFF888888)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
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
      bottomNavigationBar: bottomBar(isButtonEnabled),
      backgroundColor: const Color(0xFF1A1A1A),
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
    child: Container(
      color: const Color(0xFF1A1A1A),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => print("뒤로가기"),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//바텀 바 위젯
Widget bottomBar(bool isEnabled) {
  return Container(
    height: 68,
    color: const Color(0xFF1A1A1A),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: isEnabled
                      ? () {
                          print("버튼이 눌렸습니다");
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? const Color(0xFF05FFF7)
                          : const Color(0xFF888888),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "다음",
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
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
